//
//  ContentView.swift
//  UnsplashSwift
//
//  Created by Ahmed OMEROVIC on 1/23/24.
//

import SwiftUI
import Foundation
import UIKit

// MARK: - UnsplashPhoto
struct UnsplashPhoto: Codable, Identifiable {
    let id, slug: String
    let urls: UnsplashPhotoUrls
    let user: User
}

struct UnsplashPhotoUrls: Codable {
    let raw, full, regular, small: String
    let thumb, smallS3: String
    
    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}
struct User: Codable {
    let id, username:String
    let instagramname: String?
    let profileImage:ProfilUser
    let links:LinkUser
    
    enum CodingKeys: String, CodingKey {
        case id, username, links
        case instagramname = "instagram_username"
        case profileImage = "profile_image"
    }
}
struct ProfilUser : Codable{
    let small, medium, large: String
}

struct LinkUser : Codable{
    let html: String
}
// MARK: - UnsplashTopic
struct UnsplashTopic: Codable, Identifiable {
    let id, title: String
    let coverPhoto: CoverTopic
    
    enum CodingKeys: String, CodingKey {
        case id,title
        case coverPhoto = "cover_photo"
    }
}

struct CoverTopic: Codable {
    let urls: UnsplashPhotoUrls
}

let columns = [
    GridItem(.flexible(minimum: 150)),
    GridItem(.flexible(minimum: 150))
]

struct ContentView: View {
    @StateObject var feedState = FeedState()
    @State var imageList: [UnsplashPhoto] = []
    @State var topicList: [UnsplashTopic] = []
    var CliqueImage = false
    
    var body: some View {
        NavigationStack {
            Button(action: {
                Task {
                    await feedState.fetchFeeds()
                }
            }, label: {
                Text("Load Data")
            })
            
            if let topicFeed = feedState.topicFeed {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack() {
                        ForEach(topicFeed, id: \.id) { topic in
                            NavigationLink(destination: TopicFeedView(topic: topic)) {
                                VStack {
                                    AsyncImage(url: URL(string: topic.coverPhoto.urls.small))
                                        .frame(width: 100, height: 50)
                                        .cornerRadius(8)
                                    Text(topic.title)
                                        .foregroundStyle(.blue)
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            if let photoFeed = feedState.photoFeed {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(photoFeed, id: \.id) { image in
                            AsyncImage(url: URL(string: image.urls.small)) { image in
                                image
                                    .resizable()
                                    .frame(height: 150)
                                    .cornerRadius(12)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                    .padding(.horizontal)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .navigationTitle("Feed")
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(0..<12, id: \.self) { index in
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(height: 150)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .navigationTitle("Feed")
                .redacted(reason: .placeholder)
            }
        }
    }
}

struct TopicFeedView: View {
    let topic: UnsplashTopic
    @StateObject var feedState = FeedState()
    
    var body: some View {
        NavigationStack {
            Button(action: {
                Task {
                    await feedState.fetchTopicImages(path:"/topics/\(topic.id)/photos")
                }
            }, label: {
                Text("Load photos for topic")
            })
            if let photosTopic = feedState.topicPhotosFeed {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(photosTopic, id: \.id) { image in
                            NavigationLink(destination: InfoImageView(image: image)) {
                                AsyncImage(url: URL(string: image.urls.small)) { image in
                                    image
                                        .resizable()
                                        .frame(height: 150)
                                        .cornerRadius(12)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .navigationTitle(topic.title)
    }
}

struct InfoImageView: View {
    let image: UnsplashPhoto
    let nameUser: String
    var linkActualImage: String
    @State private var inputImage: UIImage?
    @State private var selectedImageSize: ImageSize = .full
    
    init(image: UnsplashPhoto) {
        self.image = image
        self.nameUser = "@\(String(describing: image.user.instagramname ?? image.user.username))"
        self.linkActualImage = image.urls.full
    }
    
    var body: some View {
        VStack {
            InfoImageTitreView(image: image, nameUser: nameUser)
            
            Picker("Image Size", selection: $selectedImageSize) {
                Text("Large").tag(ImageSize.full)
                Text("Medium").tag(ImageSize.regular)
                Text("Small").tag(ImageSize.small)
            }
            .pickerStyle(PalettePickerStyle())
            .padding()
            
            Spacer()
            
            selectedImageView
                .frame(height: 300)
                .cornerRadius(12)
            
            Button(action: {
                print("téléchargement")
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(.blue)
                    Text("Télécharger")
                        .foregroundColor(.blue)
                }
                .padding()
            }
            .padding()
        }
    }
    
    private var selectedImageView: some View {
        switch selectedImageSize {
        case .full:
            return AsyncImage(url: URL(string: image.urls.full)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            
        case .regular:
            return AsyncImage(url: URL(string: image.urls.regular)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            
        case .small:
            return AsyncImage(url: URL(string: image.urls.small)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
        }
    }
}

enum ImageSize {
    case full, regular, small
}

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }
}

#Preview {
    ContentView()
}



//
//  ContentView.swift
//  UnsplashSwift
//
//  Created by Ahmed OMEROVIC on 1/23/24.
//

import SwiftUI
import Foundation

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
    let firstName, lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, username
        case firstName = "first_name"
        case lastName = "last_name"
    }
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
                            AsyncImage(url: URL(string: image.urls.raw)) { image in
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
            if let photosTopic = feedState.topicPhotosFeed{
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(photosTopic, id: \.id) { image in
                            AsyncImage(url: URL(string: image.urls.raw)) { image in
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
        .navigationTitle(topic.title)
    }
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

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

// MARK: - UnsplashPhotoUrls
struct UnsplashPhotoUrls: Codable {
    let raw, full, regular, small: String
    let thumb, smallS3: String
    
    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}

// MARK: - User
struct User: Codable {
    let id, username:String
    let firstName, lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, username
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

struct ContentView: View {
    @StateObject var feedState = FeedState()
    @State var imageList: [UnsplashPhoto] = []
    var CliqueImage = false
    
    func loadData() async {
        // Créez une URL avec la clé d'API
        
        let url = URL(string: "https://api.unsplash.com/photos?client_id=\(ConfigurationManager.instance.plistDictionnary.clientId)")!
        
        do {
            // Créez une requête avec cette URL
            let request = URLRequest(url: url)
            
            // Faites l'appel réseau
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // Transformez les données en JSON
            let deserializedData = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
            
            // Mettez à jour l'état de la vue
            imageList = deserializedData
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    let columns = [
        GridItem(.flexible(minimum: 150)),
        GridItem(.flexible(minimum: 150))
    ]
    
    var body: some View {
        VStack {
            Button(action: {
                Task {
                    await feedState.fetchHomeFeed()
                }
            }, label: {
                Text("Load Data")
            })
            if let homeFeed = feedState.homeFeed {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(homeFeed, id: \.id) { image in
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
                .padding(.horizontal)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .navigationTitle("Feed")
            } else {
                // Affiche une liste de 12 rectangles dans le else
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
            }
        }}}

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

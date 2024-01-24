//
//  FeedState.swift
//  UnsplashSwift
//
//  Created by Ahmed OMEROVIC on 1/23/24.
//

import Foundation

class FeedState: ObservableObject {
    @Published var photoFeed: [UnsplashPhoto]?
    @Published var topicPhotosFeed: [UnsplashPhoto]?
    @Published var topicFeed: [UnsplashTopic]?

    func fetchFeeds() async {
        do {
            if let url = UnsplashAPI.feedUrl() {
                let request = URLRequest(url: url)
                let (photoData, _) = try await URLSession.shared.data(for: request)
                let deserializedPhotoData = try JSONDecoder().decode([UnsplashPhoto].self, from: photoData)
                DispatchQueue.main.async {
                    self.photoFeed = deserializedPhotoData
                }
            }

            if let url = UnsplashAPI.topicUrl() {
                let request = URLRequest(url: url)
                let (topicData, _) = try await URLSession.shared.data(for: request)
                let deserializedTopicData = try JSONDecoder().decode([UnsplashTopic].self, from: topicData)
                DispatchQueue.main.async {
                    self.topicFeed = deserializedTopicData
                }
            }
        } catch {
            print("Error fetching feeds: \(error)")
        }
    }
    
    func fetchTopicImages(path: String) async {
        do {
            if let url = UnsplashAPI.topicPhotosUrl(path: path) {
                let request = URLRequest(url: url)
                let (photoData, _) = try await URLSession.shared.data(for: request)
                let deserializedPhotoData = try JSONDecoder().decode([UnsplashPhoto].self, from: photoData)
                DispatchQueue.main.async {
                    self.topicPhotosFeed = deserializedPhotoData
                }
            }
        } catch {
            print("Error fetching feeds: \(error)")
        }
    }
}


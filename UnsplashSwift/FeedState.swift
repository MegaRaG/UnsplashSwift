//
//  FeedState.swift
//  UnsplashSwift
//
//  Created by Ahmed OMEROVIC on 1/23/24.
//

import Foundation

class FeedState: ObservableObject {
    @Published var homeFeed: [UnsplashPhoto]?

    // Fetch home feed utilise la fonction feedUrl de UnsplashAPI
    // Puis assigne le résultat de l'appel réseau à la variable homeFeed
    func fetchHomeFeed() async {
        do {
            if let url = UnsplashAPI.feedUrl() {
                let request = URLRequest(url: url)
                let (data, _) = try await URLSession.shared.data(for: request)
                let deserializedData = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
                
                // Met à jour l'état de homeFeed sur le thread principal
                DispatchQueue.main.async {
                    self.homeFeed = deserializedData
                }
            }
        } catch {
            print("Error fetching home feed: \(error)")
        }
    }
}

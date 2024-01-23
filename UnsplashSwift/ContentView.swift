//
//  ContentView.swift
//  UnsplashSwift
//
//  Created by Ahmed OMEROVIC on 1/23/24.
//

import SwiftUI

struct ContentView: View {
    
    let imageURLs: [String] = [
        "https://images.unsplash.com/photo-1683009427666-340595e57e43?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MzYyNDN8MXwxfGFsbHwxfHx8fHx8MXx8MTcwMzc1OTU1MXw&ixlib=rb-4.0.3&q=80&w=1080",
        "https://images.unsplash.com/photo-1563473213013-de2a0133c100?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MzYyNDN8MHwxfGFsbHwyfHx8fHx8MXx8MTcwMzc1OTU1MXw&ixlib=rb-4.0.3&q=80&w=1080",
        "https://images.unsplash.com/photo-1490349368154-73de9c9bc37c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MzYyNDN8MHwxfGFsbHwzfHx8fHx8MXx8MTcwMzc1OTU1MXw&ixlib=rb-4.0.3&q=80&w=1080",
        "https://images.unsplash.com/photo-1495379572396-5f27a279ee91?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MzYyNDN8MHwxfGFsbHw0fHx8fHx8MXx8MTcwMzc1OTU1MXw&ixlib=rb-4.0.3&q=80&w=1080",
        "https://images.unsplash.com/photo-1560850038-f95de6e715b3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MzYyNDN8MHwxfGFsbHw1fHx8fHx8MXx8MTcwMzc1OTU1MXw&ixlib=rb-4.0.3&q=80&w=1080",
        "https://images.unsplash.com/photo-1695653422715-991ec3a0db7a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MzYyNDN8MXwxfGFsbHw2fHx8fHx8MXx8MTcwMzc1OTU1MXw&ixlib=rb-4.0.3&q=80&w=1080",
        "https://images.unsplash.com/photo-1547327132-5d20850c62b5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MzYyNDN8MHwxfGFsbHw3fHx8fHx8MXx8MTcwMzc1OTU1MXw&ixlib=rb-4.0.3&q=80&w=1080",
        "https://images.unsplash.com/photo-1492724724894-7464c27d0ceb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MzYyNDN8MHwxfGFsbHw4fHx8fHx8MXx8MTcwMzc1OTU1MXw&ixlib=rb-4.0.3&q=80&w=1080",
        "https://images.unsplash.com/photo-1475694867812-f82b8696d610?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MzYyNDN8MHwxfGFsbHw5fHx8fHx8MXx8MTcwMzc1OTU1MXw&ixlib=rb-4.0.3&q=80&w=1080",
        "https://images.unsplash.com/photo-1558816280-dee9521ff364?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MzYyNDN8MHwxfGFsbHwxMHx8fHx8fDF8fDE3MDM3NTk1NTF8&ixlib=rb-4.0.3&q=80&w=1080"
    ]
    
    let columns = [
        GridItem(.flexible(minimum: 150)),
        GridItem(.flexible(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
//                    ForEach(imageURLs, id: \.self) { imageURL in
//                        AsyncImage(url: URL(string: imageURL)) {                              image in
//                            image
//                                .resizable()
//                                .frame(height: 150)
//                                .cornerRadius(12)
//                        } placeholder: {
//                            ProgressView()
//                        }
//                    }
                }
            }
            .padding(.horizontal)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .navigationTitle("Feed")
        }}
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

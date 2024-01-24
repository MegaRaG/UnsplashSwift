//
//  Extracted.swift
//  UnsplashSwift
//
//  Created by Ahmed OMEROVIC on 1/24/24.
//

import SwiftUI

struct InfoImageTitreView: View {
    let image: UnsplashPhoto
    let nameUser: String
    
    var body: some View {
        HStack{
            HStack {
                Text("Une image de \(nameUser)")
                    .font(.headline)
                    .padding()
            }
            Button(action:{
                guard let link = URL(string: image.user.links.html),
                      UIApplication.shared.canOpenURL(link) else {
                    return
                }
                UIApplication.shared.open(link,
                                          options: [:],
                                          completionHandler: nil)
            }){
                AsyncImage(url: URL(string: image.user.profileImage.medium)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                }
            }
        }
    }
}


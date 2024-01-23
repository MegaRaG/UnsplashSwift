//
//  UnsplashAPI.swift
//  UnsplashSwift
//
//  Created by Ahmed OMEROVIC on 1/23/24.
//

import Foundation

struct UnsplashAPI {
    static let scheme = "https"
    static let host = "api.unsplash.com"
    static let path = "/photos"

    static func unsplashApiBaseUrl() -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "client_id", value: ConfigurationManager.instance.plistDictionnary.clientId)
        ]
        return components
    }

    static func feedUrl(orderBy: String = "popular", perPage: Int = 10) -> URL? {
        var components = unsplashApiBaseUrl()
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: "order_by", value: orderBy),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ])

        return components.url
    }
}


//
//  Song.swift
//  Baby Ketten
//
//  Created by Christopher Schepman on 10/9/16.
//
//

import Foundation

struct Song: Codable, Equatable {
    init(artist: String, title: String, brand: String? = nil) {
        self.artist = artist
        self.title = title
        self.brand = brand
    }

    let artist: String
    let title: String
    let brand: String?

    var subtitle: String {
        if let brand, !brand.isEmpty {
            return "\(artist) (\(brand))"
        }
        return artist
    }
}

extension Song {
    var isFavorite: Bool {
        Favorites.shared.isFavorite(self)
    }

    func toggleFavorite() {
        Favorites.shared.toggleFavorite(self)
    }
}

extension Song {
    //TODO: this is nice for local testing
    //private static let urlComponents = URLComponents(string: "http://rocky.local:3000")

    private static let urlComponents = URLComponents(string: "https://bkk.schepman.org")
    private static let session = URLSession.shared

    static func songs(for term: String, searchBy: String, isRandom: Bool,
                       isPrivate: Bool = false, isLive: Bool = false) async -> [Song] {
        var searchURLComponents = urlComponents

        if isRandom {
            searchURLComponents?.path = "/random"
        } else {
            searchURLComponents?.path = "/json"
            var queryItems = [URLQueryItem(name: "search", value: term), URLQueryItem(name: "searchby", value: searchBy)]
            if isLive {
                queryItems.append(URLQueryItem(name: "live", value: "true"))
            }
            if isPrivate {
                queryItems.append(URLQueryItem(name: "db", value: "private"))
            }
            searchURLComponents?.queryItems = queryItems
        }
        let searchURL = searchURLComponents!.url!

        guard let (data, _) = try? await session.data(from: searchURL),
              let songs = try? JSONDecoder().decode([Song].self, from: data) else {
            return []
        }

        return songs
    }
}

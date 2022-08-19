//
//  Song.swift
//  Baby Ketten
//
//  Created by Christopher Schepman on 10/9/16.
//
//

import Foundation

struct Song: Codable, Equatable {
    init(artist: String, title: String, brand: String = "") {
        self.artist = artist
        self.title = title
        self.brand = brand
    }

    let artist: String
    let title: String
    let brand: String

    var subtitle: String {
        if !brand.isEmpty {
            return "\(artist) (\(brand))"
        } else {
            return artist
        }
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
    init?(json: [String: Any]) {
        guard let artist = json["artist"] as? String,
              let title = json["title"] as? String
            else {
                return nil
        }

        let brand = json["brand"] as? String ?? ""

        self.artist = artist
        self.title = title
        self.brand = brand
    }
}

extension Song {
    private static let urlComponents = URLComponents(string: "https://bkk.schepman.org")
    private static let session = URLSession.shared

    static func songs(for term: String, searchBy: String, isRandom: Bool, completion: @escaping ([Song]) -> Void) {
        var searchURLComponents = urlComponents
        var searchURL: URL

        if isRandom {
            searchURLComponents?.path = "/random"
            searchURL = searchURLComponents!.url!
        } else {
            searchURLComponents?.path = "/json"
            searchURLComponents?.queryItems = [URLQueryItem(name: "search", value: term), URLQueryItem(name: "searchby", value: searchBy)]
            searchURL = searchURLComponents!.url!
        }

        session.dataTask(with: searchURL, completionHandler: { data, _, _ in
            var songs: [Song] = []

            if let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] {
                for result in json {
                    if let song = Song(json: result) {
                        songs.append(song)
                    }
                }
            }
            
            completion(songs)
        }).resume()
    }
}

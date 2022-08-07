//
//  Song.swift
//  Baby Ketten
//
//  Created by Christopher Schepman on 10/9/16.
//
//

import Foundation

struct Song {
    let artist: String
    let title: String
}

extension Song {
    init?(json: [String: Any]) {
        guard let artist = json["artist"] as? String,
              let title = json["title"] as? String
            else {
                return nil
        }

        self.artist = artist
        self.title = title
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

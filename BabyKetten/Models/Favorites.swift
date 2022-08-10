//
//  Favorites.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/9/22.
//

import Foundation

enum Favorite: Codable {
    case song(Song)
    case folder(title: String)
}

@objc(Favorites)
class Favorites: NSObject {
    @objc public static let shared = Favorites()
    private override init() {}

    var favorites: [Favorite] = []

    var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func debugDump() {
        for f in favorites {
            print(f)
        }
    }

    @objc func favoritesAsDicts() -> [[String: String]] {
        return favorites.map { fave in
            switch fave {
            case .song(let song):
                return ["artist": song.artist, "title": song.title]
            case .folder(let title):
                return ["title": title, "isFolder": "true"]
            }
        }
    }

    @objc func load() {
        // if there are old favorites in user defaults migrate them to the new system
        if let oldfavorites = UserDefaults.standard.array(forKey:"favorites") as? [[String:String]] {
            for fave in oldfavorites {
                guard let title = fave["title"] else {
                    continue
                }

                if let artist = fave["artist"] {
                    add(.song(Song(artist: artist, title: title)))
                } else if fave["isFolder"] != nil {
                    add(.folder(title: title))
                }
            }

            // move them under a new key just in case
            //UserDefaults.standard.set(oldfavorites, forKey: "oldFavorites")

            // clear the old key
            //UserDefaults.standard.removeObject(forKey: "favorites")

            print(favorites)
        }
    }

    func isFavorite(_ song: Song) -> Bool {
        return favorites.contains { fave in
            switch fave {
            case .song(let favedSong):
                return favedSong == song
            case .folder(_):
                return false
            }
        }
    }

    func add(_ song: Song) {
        add(.song(Song(artist: song.artist, title: song.title)))
    }

    func add(_ favorite: Favorite) {
        favorites.append(favorite)
    }

    func remove(_ song: Song) {
        favorites.removeAll { fave in
            switch fave {
            case .song(let favedSong):
                return favedSong == song
            case .folder(_):
                return false
            }
        }
    }

    func toggleFavorite(_ song: Song) {
        if isFavorite(song) {
            remove(song)
        } else {
            add(song)
        }
    }
}

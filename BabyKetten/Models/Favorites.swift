//
//  Favorites.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/9/22.
//

import Foundation

class Favorites {
    public static let shared = Favorites()
    private init() {}

    // potential migration from old dicts?
    func load() {
        print("loading favorites...")
    }

    func isFavorite(song: Song) -> Bool {
        guard let favorites = UserDefaults.standard.array(forKey:"favorites") as? [[String:String]] else {
            return false
        }

        for fave in favorites {
            if fave["artist"] == song.artist && fave["title"] == song.title {
                return true
            }
        }

        return false
    }

    func setFavorite(song: Song) {
    }

    func removeFavorite(song: Song) {
    }

    func toggleFavorite(song: Song) {
        if isFavorite(song: song) {
            removeFavorite(song: song)
        } else {
            setFavorite(song: song)
        }
    }
}

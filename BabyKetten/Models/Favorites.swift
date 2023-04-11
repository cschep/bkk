//
//  Favorites.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/9/22.
//

import Foundation

enum Favorite: Codable, Equatable {
    indirect case song(Song, folder: Favorite? = nil)
    case folder(title: String)

    var title: String {
        switch self {
        case .song(let song, _):
            return song.title
        case .folder(let title):
            return title
        }
    }

    // moving a song to nil is to move it to the base level
    // is this good? I dunno but cromsy keeps laughing
    mutating func moveSong(to folder: Favorite?) {
        switch self {
        case .song(let song, _):
            self = .song(song, folder: folder)
        case .folder:
            break
        }
    }
}

class Favorites {
    public static let shared = Favorites()
    private init() {}

    private var favorites: [Favorite] = [
        .folder(title: "testing folder"),
        .song(Song(artist: "test", title: "test"))
    ]

    var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func debugDump() {
        for f in favorites {
            print(f)
        }
    }

    func load() {
        // if there are old favorites in user defaults migrate them to the new system
        if let oldfavorites = UserDefaults.standard.array(forKey:"favorites") as? [[String: String]] {
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


            // TODO !!
            // move them under a new key just in case
            //UserDefaults.standard.set(oldfavorites, forKey: "oldFavorites")

            // clear the old key
            //UserDefaults.standard.removeObject(forKey: "favorites")

            //print(favorites)
        }
    }

    func isFavorite(_ song: Song) -> Bool {
        return favorites.contains { fave in
            switch fave {
            case .song(let favedSong, _):
                return favedSong == song
            case .folder(_):
                return false
            }
        }
    }

    func favorites(inFolder: Favorite? = nil) -> [Favorite] {
        if inFolder == nil {
            return favorites
        }

        return favorites.filter { fave in
            switch fave {
            case .song(_, let folder):
                return folder == inFolder
            case .folder:
                return false
            }
        }
    }

    func folders() -> [Favorite] {
        return favorites.filter { fave in
            switch fave {
            case .song:
                return false
            case .folder:
                return true
            }
        }
    }

    func add(_ song: Song) {
        add(.song(Song(artist: song.artist, title: song.title)))
    }

    func add(_ favorite: Favorite) {
        favorites.append(favorite)
    }

    // Have to be able to move to nil, does this suck?
    func move(song: Favorite, to folder: Favorite?) {
        guard var found = favorites.first(where: { $0 == song }) else { return }
        print(found)
        found.moveSong(to: folder)
        print(found)
    }

    func remove(_ song: Song) {
        favorites.removeAll { fave in
            switch fave {
            case .song(let favedSong, _):
                return favedSong == song
            case .folder(_):
                return false
            }
        }
    }

    func toggleFavorite(_ song: Song) {
        isFavorite(song) ? remove(song) : add(song)
    }
}

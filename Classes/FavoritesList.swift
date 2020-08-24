//
//  FavoritesList.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/21/20.
//

import Foundation

enum FavoriteItem {
    case folder(name: String, folder: String? = nil)
    case song(Song, folder: String? = nil)

    var id: String {
        switch self {
        case .song(let song, _):
            return song.id
        case .folder(let name, _):
            return name
        }
    }

    var inFolderName: String {
        switch self {
        case .song(_, let folder):
            return folder ?? ""
        case .folder(_, let folder):
            return folder ?? ""
        }
    }
}

class FavoritesList: ObservableObject {
    static let shared = FavoritesList()

    private init() {
        self.sort()
    }

    @Published var favorites: [FavoriteItem] = [
        .folder(name: "Folder 1"),
        .song(Song(artist: "coheed", title: "awesome")),
        .song(Song(artist: "coheed", title: "awesome again")),
        .song(Song(artist: "coheed", title: "awesome three")),
        .song(Song(artist: "coheed", title: "awesome in folder"), folder: "Folder 1")
    ]

    func toggle(song: Song) {
        if contains(item: .song(song)) {
            remove(item: .song(song))
        } else {
            add(item: .song(song))
        }
    }

    func add(item: FavoriteItem) {
        if !contains(item: item) {
            favorites.append(item)
            sort()
        }

        //TODO: return result for failure?
    }

    func remove(item: FavoriteItem) {
        favorites.removeAll { i in
            i.id == item.id
        }
        sort()

        //TODO: and remove all the folder's contents
    }

    func remove(for id: String) {
        favorites.removeAll { (item) -> Bool in
            item.id == id
        }
    }

    func contains(item: FavoriteItem) -> Bool {
        return self.favorites.contains { i in
            i.id == item.id
        }
    }

    private func sort() {
        self.favorites.sort { (lhs, rhs) -> Bool in
            switch (lhs, rhs) {
            case (.folder(let lName, _), .folder(let rName, _)):
                return lName.caseInsensitiveCompare(rName) == .orderedAscending
            case (.folder, .song):
                return true
            case (.song, .folder):
                return false
            case (.song(let lSong, _), .song(let rSong, _)):
                switch lSong.artist.caseInsensitiveCompare(rSong.artist) {
                case .orderedAscending:
                    return true
                case .orderedSame:
                    return lSong.title.caseInsensitiveCompare(rSong.title) == .orderedAscending
                case .orderedDescending:
                    return false
                }
            }
        }
    }
 }

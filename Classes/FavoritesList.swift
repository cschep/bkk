//
//  FavoritesList.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/21/20.
//

import Foundation

//protocol FavoriteItem {
//    var id: String { get }
//    var title: String { get }
//    var artist: String { get }
//    var isFolder: Bool { get }
//}

enum FavoriteItem {
    case folder(FavoritesFolder)
    case song(Song)

    var id: String {
        switch self {
        case .song(let song):
            return song.id
        case .folder(let folder):
            return folder.name
        }
    }
}

struct FavoritesFolder {
    let name: String
}

class FavoritesList: ObservableObject {

    private init() { }

    static let shared = FavoritesList()

    @Published var favorites: [FavoriteItem] = []

    func toggle(song: Song) {
        if contains(item: .song(song)) {
            remove(item: .song(song))
        } else {
            add(item: .song(song))
        }
    }

    func add(item: FavoriteItem) {
        // TODO: check for dupes
        self.favorites.append(item)
    }

    func remove(item: FavoriteItem) {
        favorites.removeAll { i in
            i.id == item.id
        }

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
 }

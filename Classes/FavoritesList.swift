//
//  FavoritesList.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/21/20.
//

import Foundation

protocol FavoriteItem {
    var id: String { get }
    var title: String { get }
    var isFolder: Bool { get }
}

struct FavoritesFolder: FavoriteItem {
    var id: String {
        title
    }

    let title: String
    let isFolder = true
}

class FavoritesList: ObservableObject {

    private init() { }

    static let shared = FavoritesList()

    @Published var favorites: [FavoriteItem] = []

    func toggle(song: Song) {
        if contains(item: song) {
            remove(item: song)
        } else {
            add(item: song)
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

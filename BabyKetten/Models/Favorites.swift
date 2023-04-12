//
//  Favorites.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/9/22.
//

import Foundation

@objc public class FavoritesRootFolder: NSObject {
    @objc public static let name: String = "_root_bkk_folder_"
    override private init() {}
}

public class Favorites {
    public static let shared = Favorites()
    private init() {}

    private static let defaultsKey = "bkk_favorites_db"
    private static let migratedKey = "bkk_favorites_migrated"
    private static let oldDefaultsKey = "favorites"

    private var db: [String: [Song]] = [FavoritesRootFolder.name: []]
    private var defaults = UserDefaults.standard

    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func debugDump() {
        for (folder, songs) in db {
            print("--", folder, "--")
            for song in songs {
                print(song)
            }
        }
    }

    func load() {
        //TODO: REMOVE
//        defaults.set(false, forKey: Favorites.migratedKey)
        //


        // if there are any existing faves in the new system, load them all in
        if let defaultsDb = defaults.data(forKey: Favorites.defaultsKey) {
            if let decodedDb = try? JSONDecoder().decode([String: [Song]].self, from: defaultsDb) {
                db = decodedDb
            }
        }

        // then, if we haven't migrated, let's do it. -- SHOULD BE non-destructive!
        // 👹 cromslor won't stop laughing -- no help at all.
        if defaults.bool(forKey: Favorites.migratedKey) == false {
            migrate()
        }

    }

    func save() {
        if let encodedDb = try? JSONEncoder().encode(db) {
            defaults.set(encodedDb, forKey: Favorites.defaultsKey)
        }
    }

    func migrate() {
        print("MIGRATING")

        // if there are old favorites in user defaults migrate them to the new system
        if let oldfavorites = UserDefaults.standard.array(forKey: Favorites.oldDefaultsKey) as? [[String: String]] {
            for fave in oldfavorites {

                // has to have a title
                guard let title = fave["title"] else {
                    continue
                }

                // if it has an artist, it's a song so we add it!
                if let artist = fave["artist"] {
                    let song = Song(artist: artist, title: title)
                    add(song: song)
                    if let folderName = fave["folder"] {
                        // if it was in a folder then add the folder and move the song to it
                        add(folderName: folderName)
                        move(song: song, to: folderName)
                    }
                }

                // just to make sure we add any empty folders
                // will skip any existing folders so this is harmless
                if let isFolder = fave["isFolder"], isFolder == "true" {
                    add(folderName: title)
                }
            }
        }

        defaults.set(true, forKey: Favorites.migratedKey)
    }



    func isFavorite(_ song: Song) -> Bool {
        for (_, songs) in db {
            if songs.contains(song) { return true }
        }
        return false
    }

    func favorites(in folderName: String = FavoritesRootFolder.name) -> [Song] {
        db[folderName] ?? []
    }

    func displayFavorites(in folderName: String = FavoritesRootFolder.name) -> [DisplayFavorite] {
        var result: [DisplayFavorite] = []
        if folderName == FavoritesRootFolder.name {
            result += folders().map { .folder(folderName: $0) }
        }
        result += favorites(in: folderName).map { .song(song: $0) }

        return result
    }

    func folders() -> [String] {
        db.keys
            .filter { $0 != FavoritesRootFolder.name }
            .sorted()
    }

    // save after all adds and removes
    func add(song: Song, folderName: String = FavoritesRootFolder.name) {
        guard isFavorite(song) == false else { return } // prevent dupes
        db[folderName]?.append(song)
        save()
    }

    func add(folderName: String) {
        guard db.keys.contains(folderName) == false else { return } //do not overwrite key
        db[folderName] = []
        save()
    }

    func remove(_ song: Song) {
        for (foundFolder, _) in db {
            db[foundFolder]?.removeAll { $0 == song }
        }
        save()
        debugDump()
    }

    func remove(folderName: String) {
        db.removeValue(forKey: folderName)
        save()
        debugDump()
    }

    func move(song: Song, to folderName: String) {
        // don't delete it unless we have somewhere for it to go
        // croms doesn't think this needs to exist but I'm wary of his cowboy nature
        guard db.keys.contains(folderName) == true else { return }
        remove(song)
        add(song: song, folderName: folderName)
    }

    func toggleFavorite(_ song: Song) {
        isFavorite(song) ? remove(song) : add(song: song)
    }
}

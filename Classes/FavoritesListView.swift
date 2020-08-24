//
//  FavoritesListView.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/21/20.
//

import SwiftUI

struct FavoritesListView: View {
    @ObservedObject var favoritesList: FavoritesList = .shared

    @State var editMode: EditMode = .inactive
    @State var selection = Set<String>()
    @State var isCreatingFolder = false

    var folderName: String? = nil

    var body: some View {
        ZStack {
            List(selection: $selection) {
                ForEach(favoritesList.favorites.filter({ item in
                    if let folderName = folderName {
                        return item.inFolderName == folderName
                    }

                    return true
                }), id: \.id) { item in
                    item.destination
                }
                .onDelete(perform: delete)
            }
            .environment(\.editMode, .constant(self.editMode)).animation(.spring())
            .alert(isPresented: $isCreatingFolder, TextAlert(title: "New Folder", message: "name of the new folder?") { result in
                if let newFolderName = result {
                    self.favoritesList.add(item: .folder(name: newFolderName, folder: self.folderName))
                }
            })
            .navigationBarTitle(self.folderName ?? "Favorites!")
            .navigationBarItems(
                trailing: buttonRow
            )
        }
    }

    private var buttonRow: some View {
        HStack {
            if self.editMode == .inactive {
                Button(action: {
                    self.isCreatingFolder = true
                }) {
                    Image(systemName: "folder.badge.plus")
                }
            } else {
                Button(action: {
                    print("deleting \(self.selection)")
                }) {
                    Image(systemName: "trash")
                }

                Button(action: {
                    print("moving \(self.selection)")
                }) {
                    Image(systemName: "arrow.up.doc")
                }
            }

            Button(action: {
                self.editMode = self.editMode == .active ? .inactive : .active
            }) {
                Text(self.editMode == .inactive ? "Edit" : "Done")
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        let filtered = favoritesList.favorites.filter { item in
            if let folderName = folderName {
                return item.inFolderName == folderName
            }

            return true
        }

        for index in offsets {
            let toDelete = filtered[index]
            favoritesList.remove(item: toDelete)
        }
    }
}

extension FavoriteItem {
    var destination: some View {
        switch self {
        case .song(let song, _):
            return AnyView(
                NavigationLink(destination: SongDetailView(song: song)) {
                    SongCell(song: song)
                }
            )
        case .folder(let name, _):
            return AnyView(
                NavigationLink(destination: FavoritesListView(folderName: name)) {
                    HStack {
                        Image(systemName: "folder")
                        Text(name)
                    }
                }
            )
        }
    }
}

struct FavoritesListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FavoritesListView()
        }
    }
}

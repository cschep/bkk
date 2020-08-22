//
//  FavoritesListView.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/21/20.
//

import SwiftUI

struct FavoritesListView: View {
    @ObservedObject var favoritesList: FavoritesList = .shared

    @State var isEditMode: EditMode = .inactive
    @State var selection = Set<String>()
    @State var showsFolderAlert = false

    var body: some View {
        List(selection: $selection) {
            ForEach(favoritesList.favorites, id: \.id) { item in
                self.itemView(item: item)
            }
            .onMove(perform: move)
        }
        .listStyle(GroupedListStyle())
//        .alert(isPresented: $showsFolderAlert, TextAlert(title: "New Folder", message: "name of the new folder?", action: {
//            guard let folderName = $0 else {
//                return
//            }
//
//            self.favoritesList.add(item: .folder(FavoritesFolder(name: folderName)))
//        }))
        .navigationBarTitle("Favorites")
        .navigationBarItems(
            leading: addFolderButton,
            trailing: EditButton()
        )
        .environment(\.editMode, self.$isEditMode)
    }

    private func move(from source: IndexSet, to destination: Int) {
        favoritesList.favorites.move(fromOffsets: source, toOffset: destination)
    }

    private func itemView(item: FavoriteItem) -> AnyView {
        switch item {
        case .song(let song):
            return AnyView(
                NavigationLink(destination: SongDetailView(song: song)) {
                    SongCell(song: song)
                }
            )
        case .folder(let folder):
            return AnyView(
                NavigationLink(destination: Text(folder.name)) {
                    HStack {
                        Image(systemName: "folder")
                        Text(folder.name)
                    }
                }
            )
        }
    }

    private var addFolderButton: some View {
        HStack {
            Button(action: {
//                self.showsFolderAlert = true
                self.favoritesList.add(item: .folder(FavoritesFolder(name: "new folder \(Date())")))
            }) {
                Image(systemName: "folder.badge.plus")
            }

            deleteButton
         }
    }

    private var deleteButton: some View {
        Group {
            if isEditMode == .active {
                Button(action: delete) {
                    Image(systemName: "trash")
                }
            }
        }
    }

    func delete() {
        print("removing \(selection)")

        for id in selection {
            FavoritesList.shared.remove(for: id)
        }

        selection = Set<String>()
    }
}

struct FavoritesListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FavoritesListView()
        }
    }
}

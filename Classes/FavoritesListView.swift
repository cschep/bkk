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
                Text(item.title)
            }
        }
        .alert(isPresented: $showsFolderAlert, TextAlert(title: "New Folder", message: "name of the new folder?", action: {
            guard let folderName = $0 else {
                return
            }

            self.favoritesList.add(item: FavoritesFolder(title: folderName))
        }))
        .navigationBarTitle("Favorites")
        .navigationBarItems(
            leading: addFolderButton,
            trailing: EditButton()
        )
        .environment(\.editMode, self.$isEditMode)
    }

    private var addFolderButton: some View {
        HStack {
            Button(action: {
                self.showsFolderAlert = true
            }) {
                Image(systemName: "folder.badge.plus")
            }

            deleteButton
         }
    }

    private var deleteButton: some View {
        if isEditMode == .inactive {
            return Button(action: {}) {
                Image(systemName: "")
            }
        } else {
            return Button(action: delete) {
                Image(systemName: "trash")
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

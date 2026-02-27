import UIKit

class FavoritesCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = makeFavoritesVC(folder: FavoritesRootFolder.name)
        navigationController.pushViewController(vc, animated: false)
    }

    private func makeFavoritesVC(folder: String) -> FavoritesListTableViewController {
        let vc = FavoritesListTableViewController()
        vc.currentFolder = folder

        vc.onSongSelected = { [weak self] song in
            self?.showSongDetail(song: song)
        }
        vc.onFolderSelected = { [weak self] folderName in
            self?.showFolder(folderName)
        }
        vc.onMoveRequested = { [weak self, weak vc] songs, folders in
            guard let self, let vc else { return }
            self.presentFolderPicker(for: songs, folders: folders, from: vc)
        }

        return vc
    }

    private func showFolder(_ name: String) {
        let vc = makeFavoritesVC(folder: name)
        navigationController.pushViewController(vc, animated: true)
    }

    private func showSongDetail(song: Song) {
        let vc = SongDetailTableViewController(song: song)
        vc.onArtistSearch = { [weak self] artist in
            self?.showArtistSongs(artist: artist)
        }
        vc.onYouTubeSearch = { [weak self] searchString in
            self?.showYouTubeSearch(searchString: searchString)
        }
        navigationController.pushViewController(vc, animated: true)
    }

    private func showArtistSongs(artist: String) {
        Song.songs(for: artist, searchBy: "artist", isRandom: false) { [weak self] songs in
            DispatchQueue.main.async {
                guard let self else { return }
                let vc = SongListTableViewController()
                vc.songs = songs
                vc.title = artist
                vc.onSongSelected = { [weak self] song in
                    self?.showSongDetail(song: song)
                }
                self.navigationController.pushViewController(vc, animated: true)
            }
        }
    }

    private func showYouTubeSearch(searchString: String) {
        let vc = YTSearchTableViewController()
        vc.searchString = searchString
        navigationController.pushViewController(vc, animated: true)
    }

    private func presentFolderPicker(for songs: [Song], folders: [String], from favesVC: FavoritesListTableViewController) {
        let vc = FolderPickerTableViewController()
        vc.folderList = folders
        vc.onFolderPicked = { [weak favesVC] folderName in
            if let folderName {
                for song in songs {
                    Favorites.shared.move(song: song, to: folderName)
                }
                favesVC?.refreshDisplayList()
                favesVC?.setEditing(false, animated: true)
                favesVC?.updateButtonsToMatchTableState()
            } else {
                favesVC?.setEditing(false, animated: true)
            }
        }
        let nc = UINavigationController(rootViewController: vc)
        navigationController.present(nc, animated: true)
    }
}

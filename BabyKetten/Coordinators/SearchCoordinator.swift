import UIKit

class SearchCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = SearchViewController()
        vc.onSearch = { [weak self] term, searchBy, isPrivate in
            self?.showSongList(term: term, searchBy: searchBy, isPrivate: isPrivate)
        }
        navigationController.pushViewController(vc, animated: false)
    }

    private func showSongList(term: String, searchBy: String, isPrivate: Bool) {
        let vc = SongListTableViewController()
        vc.searchTerm = term
        vc.searchBy = searchBy
        vc.isPrivate = isPrivate
        vc.startLoading()
        vc.onSongSelected = { [weak self] song in
            self?.showSongDetail(song: song)
        }
        navigationController.navigationBar.isHidden = false
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
        Task {
            let songs = await Song.songs(for: artist, searchBy: "artist", isRandom: false)
            let vc = SongListTableViewController()
            vc.songs = songs
            vc.title = artist
            vc.onSongSelected = { [weak self] song in
                self?.showSongDetail(song: song)
            }
            self.navigationController.pushViewController(vc, animated: true)
        }
    }

    private func showYouTubeSearch(searchString: String) {
        let vc = YTSearchTableViewController()
        vc.searchString = searchString
        navigationController.pushViewController(vc, animated: true)
    }
}

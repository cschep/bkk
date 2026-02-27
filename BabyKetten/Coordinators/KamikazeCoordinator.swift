import UIKit

class KamikazeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = KamikazeViewController()
        vc.onShakeComplete = { [weak self] in
            self?.showRandomSongList()
        }
        navigationController.pushViewController(vc, animated: false)
    }

    private func showRandomSongList() {
        let vc = SongListTableViewController()
        vc.setupRandom()
        vc.onSongSelected = { [weak self] song in
            self?.showSongDetail(song: song)
        }
        navigationController.pushViewController(vc, animated: false)
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
}

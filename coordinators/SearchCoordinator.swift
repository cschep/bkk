//
//  SearchCoordinator.swift
//  baby ketten
//
//  Created by Christopher Schepman on 7/19/19.
//

import UIKit

protocol SearchDelegate: class {
    func searchCompleted(with searchTerm: String, searchBy: String)
}

protocol SearchListDelegate: class {
    func selected(_ song: Song)
}

protocol SongDetailDelegate: class {
    func artistSearchRequested(for song: Song)
    func lyricsSearchRequested(for song: Song)
    func youtubeSearchRequested(for song: Song)
}

final class SearchCoordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(title: "search", image: UIImage(systemName: "music.mic"), tag: 0)
        self.navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
//        var searchView = SearchView()
//        searchView.delegate = self

        let bkkVC = BKKViewController(nibName: "bkkViewController_iPhone5", bundle: .main)
        navigationController.pushViewController(bkkVC, animated: false)
    }
}

extension SearchCoordinator: SearchDelegate {
    func searchCompleted(with searchTerm: String, searchBy: String) {
        Song.songs(for: searchTerm, searchBy: searchBy, isRandom: false) { songs in
//            var songListView = SongListView(searchTerm: searchTerm, songs: songs)
//            songListView.delegate = self

            let vc = SongListTableViewController()

            DispatchQueue.main.async {
                self.navigationController.pushViewController(vc, animated: true)
            }
        }
    }
}

extension SearchCoordinator: SearchListDelegate {
    func selected(_ song: Song) {
//        var songDetailView = SongDetailView(song: song)
//        songDetailView.delegate = self

        let vc = SongDetailTableViewController(song: song)
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension SearchCoordinator: SongDetailDelegate {
    func artistSearchRequested(for song: Song) {
        self.navigationController.popViewController(animated: false)

        Song.songs(for: song.artist, searchBy: "artist", isRandom: false) { songs in
            var songListView = SongListView(searchTerm: song.artist, songs: songs)
            songListView.delegate = self

            let songListVC = SongListTableViewController()
            songListVC.searchTerm = song.artist
            songListVC.searchBy = "artist"

            DispatchQueue.main.async {
                self.navigationController.pushViewController(songListVC, animated: true)
            }
        }
    }
    
    func lyricsSearchRequested(for song: Song) {
    }
    
    func youtubeSearchRequested(for song: Song) {
    }
}

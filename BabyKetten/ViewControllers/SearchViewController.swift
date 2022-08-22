//
//  SearchViewController.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/21/22.
//

import Foundation

class SearchViewController: UIViewController {
    let buttonStack: UIStackView = {
        var buttons: [UIButton] = []
        for i in 0..<4 {
            let b = UIButton(type: .custom)
            b.setImage(UIImage(named: "ketten_small_white"), for: .normal)
            buttons.append(b)
        }

        let topRow = UIStackView(arrangedSubviews: [buttons[0], buttons[1]])
        topRow.axis = .horizontal
        topRow.spacing = 10
        topRow.distribution = .fillEqually

        let bottomRow = UIStackView(arrangedSubviews: [buttons[2], buttons[3]])
        bottomRow.axis = .horizontal
        bottomRow.spacing = 10
        bottomRow.distribution = .fillEqually

        let sv = UIStackView(arrangedSubviews: [topRow, bottomRow])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 10

        return sv
    }()

    var searchController: UISearchController!

    override func viewDidLoad() {
        let songListVC = SongListTableViewController()
        songListVC.didSelectSong = songSelected(song:)
        searchController = UISearchController(searchResultsController: songListVC)
        searchController.searchBar.scopeButtonTitles = ["artist", "title", "brand"]
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        navigationItem.searchController = searchController

        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)

        let constraints = [
//            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
//            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            buttonStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            buttonStack.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
        ]

        NSLayoutConstraint.activate(constraints)

        title = "Search"

        super.viewDidLoad()
    }

    func songSelected(song: Song) {
        let vc = SongDetailTableViewController(song: song)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //search()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        search()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearSearch()
    }

    func clearSearch() {
        if let songListVC = searchController.searchResultsController as? SongListTableViewController {
            DispatchQueue.main.async {
                songListVC.songs = []
                songListVC.tableView.reloadData()
            }
        }
    }

    func search() {
        if let songListVC = searchController.searchResultsController as? SongListTableViewController,
           let searchTerm = searchController.searchBar.text {

            let scopes = ["artist", "title", "brand"]
            let searchBy = scopes[searchController.searchBar.selectedScopeButtonIndex]

            Song.songs(for: searchTerm, searchBy: searchBy, isRandom: false) { songs in
                DispatchQueue.main.async {
                    songListVC.songs = songs
                    songListVC.tableView.reloadData()
                }
            }
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        clearSearch()
        return true
    }
}

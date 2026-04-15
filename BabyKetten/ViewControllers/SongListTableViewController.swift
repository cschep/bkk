//
//  SongListTableViewController.swift
//  Baby Ketten
//
//  Created by Christopher Schepman on 10/9/16.
//
//

import UIKit

class SongListTableViewController: UITableViewController {
    enum State {
        case loading
        case empty
        case loaded
    }

    let spinner = SpinnerViewController()

    var state: State = .loading {
        didSet {
            switch state {
            case .loading:
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner.view)
            case .loaded, .empty:
                navigationItem.rightBarButtonItem = nil
                tableView.reloadData()
            }
        }
    }

    var onSongSelected: ((Song) -> Void)?

    var songs: [Song] = []
    var searchTerm: String?
    var searchBy: String?
    var isPrivate: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "SongCell")
        title = searchTerm
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        switch state {
        case .loaded, .empty:
            if songs.count == 0 {
                tableView.setEmptyMessage("nothing found!")
            } else {
                tableView.restore()
            }
        case .loading:
            break
        }

        return songs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)

        let song = songs[indexPath.row]
        cell.textLabel?.text = song.title
        cell.detailTextLabel?.text = song.subtitle
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songs[indexPath.row]
        onSongSelected?(song)
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func setupRandom() {
        tableView.backgroundView = nil
        let refresh = UIRefreshControl()
        refresh.addAction(UIAction { [weak self] _ in
            self?.randomize()
        }, for: .valueChanged)
        refreshControl = refresh
        title = "kamikaze!"
        randomize()
    }

    // Intentionally bypasses the `state` machine: this path is driven by
    // UIRefreshControl, which owns its own spinner.
    func randomize() {
        Task {
            songs = await Song.songs(for: "", searchBy: "", isRandom: true)
            tableView.refreshControl?.endRefreshing()
            tableView.reloadData()
        }
    }

    func startLoading() {
        guard let searchTerm = searchTerm,
              let searchBy = searchBy,
              let isPrivate = isPrivate else { return }

        state = .loading
        Task {
            let songs = await Song.songs(for: searchTerm, searchBy: searchBy, isRandom: false, isPrivate: isPrivate)
            self.songs = songs
            self.state = .loaded
        }
    }
}

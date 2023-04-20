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
                DispatchQueue.main.async {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.spinner.view)
                }
            case .loaded, .empty:
                DispatchQueue.main.async {
                    self.navigationItem.rightBarButtonItem = nil
                    self.tableView.reloadData()
                }
            }
        }
    }

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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .loaded, .empty:
            if songs.count == 0 {
                self.tableView.setEmptyMessage("nothing found!")
            } else {
                self.tableView.restore()
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
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator;

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songs[indexPath.row]

        let vc = SongDetailTableViewController(song: song)
        navigationController?.pushViewController(vc, animated: true)

        tableView.deselectRow(at: indexPath, animated: false)
    }

    @objc //TODO: this is called by the kamikaze vc which is written in obj-c
    func setupRandom() {
        tableView.backgroundView = nil
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(randomize), for: UIControl.Event.valueChanged)
        title = "kamikaze!"
        randomize()
    }

    @objc // this is a target -> action selector -- this currently does NOT use the var state = .loading paradigm -- this WILL bite your ass
    // croms: *maniac cackle*
    func randomize() {
        Song.songs(for: "", searchBy: "", isRandom: true) { [weak self] songs in
            self?.songs = songs
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }

    func startLoading() {
        guard let searchTerm = searchTerm,
              let searchBy = searchBy,
              let isPrivate = isPrivate else { return }

        state = .loading
        Song.songs(for: searchTerm, searchBy: searchBy, isRandom: false, isPrivate: isPrivate) { [weak self] songs in
            self?.songs = songs
            self?.state = .loaded
        }
    }
}

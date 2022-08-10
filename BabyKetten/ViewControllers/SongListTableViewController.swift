//
//  SongListTableViewController.swift
//  Baby Ketten
//
//  Created by Christopher Schepman on 10/9/16.
//
//

import UIKit

class SongListTableViewController: UITableViewController {
    @objc public var searchTerm: String = ""
    @objc public var searchBy: String = ""
    @objc public var random: Bool = false

    private var songs: [Song] = []
    private var activityIndicator = UIActivityIndicatorView(frame: CGRect(0, 0, 20, 20))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.color = UIColor.black

        let activityBarButton = UIBarButtonItem(customView: self.activityIndicator)
        self.navigationItem.rightBarButtonItem = activityBarButton

        if random {
            refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self, action: #selector(refreshSongs), for: UIControl.Event.valueChanged)
        }

        loadSongs(updateUI: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SongCell")

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "SongCell")
        }

        if let cell = cell {
            let song = songs[indexPath.row]
            cell.textLabel!.text = song.title
            cell.detailTextLabel!.text = song.artist
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator;
        }

        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songs[indexPath.row]

        let detailVC = SongDetailTableViewController(song: song)
        self.navigationController?.pushViewController(detailVC, animated: true)

    }

    @objc func refreshSongs() {
        loadSongs(updateUI: false)
    }

    func loadSongs(updateUI: Bool) {
        if updateUI {
            startLoadingUI()
        }

        Song.songs(for: searchTerm, searchBy: searchBy, isRandom: random) { songs in
            DispatchQueue.main.async {
                self.songs = songs
                self.tableView.reloadData()
                self.stopLoadingUI()
            }

//            let when = DispatchTime.now() + 2
//            DispatchQueue.main.asyncAfter(deadline: when){
//                self.songs = songs
//                self.tableView.reloadData()
//                self.stopLoadingUI()
//            }
        }
    }

    func startLoadingUI() {
        self.activityIndicator.startAnimating()
        self.navigationItem.title = "Loading..."
    }

    func stopLoadingUI() {
        if (songs.count == 0) {
            self.navigationItem.title = "Not Found!";
        } else {
            if (random) {
                self.navigationItem.title = "Kamikaze!";
            } else {
                self.navigationItem.title = "Results";
            }
        }

        self.refreshControl?.endRefreshing()
        self.activityIndicator.stopAnimating()
        self.tableView.flashScrollIndicators()
    }
}

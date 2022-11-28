//
//  SongListTableViewController.swift
//  Baby Ketten
//
//  Created by Christopher Schepman on 10/9/16.
//
//

import UIKit

class SongListTableViewController: UITableViewController {
    var songs: [Song] = []

    var didSelectSong: ((Song) -> ())?

    init() {
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "SongCell")

//        title = "Results"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

        //TODO: is this a useful thing?
        didSelectSong?(song)

        let vc = SongDetailTableViewController(song: song)
        navigationController?.pushViewController(vc, animated: true)

        tableView.deselectRow(at: indexPath, animated: false)
    }

    @objc
    func setupRandom() {
        tableView.backgroundView = nil
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(randomize), for: UIControl.Event.valueChanged)
        randomize()
    }

    @objc
    func randomize() {
        Song.songs(for: "", searchBy: "", isRandom: true) { songs in
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.songs = songs
                self.tableView.reloadData()
            }
        }
    }
}

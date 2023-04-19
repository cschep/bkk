//
//  SongListTableViewController.swift
//  Baby Ketten
//
//  Created by Christopher Schepman on 10/9/16.
//
//

import UIKit

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)
    var spinningKetten = UIImageView(image: UIImage(named: "ketten_small_white"))

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = .greatestFiniteMagnitude
        rotation.isRemovedOnCompletion = false
        spinningKetten.layer.add(rotation, forKey: "rotationAnimation")

        spinningKetten.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinningKetten)

        NSLayoutConstraint.activate([
            spinningKetten.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinningKetten.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

class SongListTableViewController: UITableViewController {
    var songs: [Song] = []

    init() {
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "SongCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if songs.count == 0 {
            self.tableView.setEmptyMessage("nothing found!")
        } else {
            self.tableView.restore()
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

    @objc // this is a target -> action selector
    func randomize() {
        Song.songs(for: "", searchBy: "", isRandom: true) { [weak self] songs in
            self?.songs = songs
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }
}

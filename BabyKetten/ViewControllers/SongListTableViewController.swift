//
//  SongListTableViewController.swift
//  Baby Ketten
//
//  Created by Christopher Schepman on 10/9/16.
//
//

import UIKit

class SongListTableViewController: UITableViewController {
    let loadingView: UIView = {
        let imageView = UIImageView(image: UIImage(named: "ketten_small_white"))
        imageView.frame = CGRect(x: 0, y: 0, width: 35, height: 28)
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = .greatestFiniteMagnitude
        imageView.layer.add(rotation, forKey: "rotationAnimation")

        let loadingView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        imageView.center.y = loadingView.center.y
        imageView.center.x = loadingView.center.x
        loadingView.addSubview(imageView)

        return loadingView
    }()

    var songs: [Song] = []
    var searchTerm: String = ""
    var searchBy: String = ""

    var loadingSongs = true

    init() {
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "SongCell")

//        navigationItem.titleView = loadingView
        tableView.setLoading()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadSongs(for: searchTerm, searchBy: searchBy) { [weak self] songs in
            DispatchQueue.main.async {
//                UIView.animate(withDuration: 0.3, animations: {
//                    self?.loadingView.alpha = 0
//                }) { _ in
//                    self?.navigationItem.titleView = nil
//                }

                self?.refreshControl?.endRefreshing()

                if songs.count == 0 {
                    self?.tableView.setEmptyMessage("nothing found!")
                } else {
                    self?.tableView.restore()
                }

                self?.songs = songs
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if songs.count == 0 && !loadingSongs {
//            self.tableView.setEmptyMessage("nothing found!")
//        } else {
//            self.tableView.restore()
//        }

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

    func loadSongs(for term: String = "", searchBy: String = "", isRandom: Bool = false, completion: (([Song])->Void)? = nil) {
        loadingSongs = true
        Song.songs(for: term, searchBy: searchBy, isRandom: isRandom) { [weak self] songs in
            self?.loadingSongs = false
            completion?(songs)
        }
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
        loadSongs(isRandom: true)
    }
}

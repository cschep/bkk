//
//  SongListTableViewController.swift
//  Baby Ketten
//
//  Created by Christopher Schepman on 10/9/16.
//
//

import UIKit

class SongListTableViewController: UITableViewController {

    public var searchTerm: String = ""
    public var searchBy: String = ""
    public var random: Bool = false

    private var songs: [Song] = []
    private var activityIndicator = UIActivityIndicatorView(frame: CGRect(0, 0, 20, 20))

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SongCell")

//        let song = Song(artist: "beebs", title: "what do u mean")
//        songs = [song]

        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.color = UIColor.black

        //Create an instance of Bar button item with custome view which is of activity indicator
//        UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
        let activityBarButton = UIBarButtonItem(customView: self.activityIndicator)

        //Set the bar button the navigation bar
//        [self navigationItem].rightBarButtonItem = barButton;
        self.navigationItem.rightBarButtonItem = activityBarButton

        if random {
            refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self, action: #selector(refreshSongs), for: UIControlEvents.valueChanged)
        }

//        [self startLoadingUI];
//        [self loadSongs];

        loadSongs(updateUI: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "SongCell")
        }

        if let cell = cell {
            let song = songs[indexPath.row]
            cell.textLabel!.text = song.title
            cell.detailTextLabel!.text = song.artist
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        }

        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songs[indexPath.row]

        let detailVC = SongDetailTableViewController(song: song)
        self.navigationController?.pushViewController(detailVC, animated: true)

    }

    ////////
    func refreshSongs() {
        loadSongs(updateUI: false)
    }

    func loadSongs(updateUI: Bool) {
        if updateUI {
            startLoadingUI()
        }

        Song.songs(for: searchTerm, searchBy: searchBy, isRandom: random) { (songs) in
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

//
//  SongDetailTableViewController.swift
//  Baby Ketten
//
//  Created by Christopher Schepman on 11/25/16.
//
//

import UIKit

class SongDetailTableViewController: UITableViewController {

    @IBOutlet var headerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!

    var song: Song
    var isFavorite: Bool = false
    var favoriteCell: UITableViewCell?

    init(song: Song) {
        self.song = song
        super.init(nibName: "SongDetailViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        favoriteCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        setCheckmarkForFavorite()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Details"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier: String = "SongDetailCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)

        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }

        if let cell = cell {
            //menu stuff
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    cell.textLabel!.text = "Favorite"

                    if (self.isFavorite) {
                        cell.accessoryType = .checkmark
                    }

                } else if (indexPath.row == 1) {
                    cell.textLabel!.text = "More By This Artist"
                }
            } else if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    cell.textLabel!.text = "Lyrics Search"
                } else if (indexPath.row == 1) {
                    cell.textLabel!.text = "YouTube Search"
                }
            }
        }

        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {

            if (indexPath.row == 0) {

                //[self toggleFavorite];

                isFavorite = !isFavorite;
                setCheckmarkForFavorite()

            } else if (indexPath.row == 1) {
                self.artistSearch()
            }

        } else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
//                [self lyricsSearch];
            } else if (indexPath.row == 1) {
                youTubeSearch()
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if (section == 1) {
            return "Searches will open a browser window."
        } else {
            return nil;
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0) {

            self.artistLabel.text = song.artist;
            self.titleLabel.text = song.title;


            return self.headerView;
        } else {
            return nil;
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 116;
        } else {
            return 24;
        }
    }

    func setCheckmarkForFavorite() {
        if isFavorite {
            favoriteCell?.accessoryType = .checkmark
        } else {
            favoriteCell?.accessoryType = .none
        }
    }

    //actions
    func artistSearch() {
        let vc = SongListTableViewController(style: .plain)
        vc.searchTerm = song.artist
        vc.searchBy = "artist"
        vc.random = false

        navigationController?.pushViewController(vc, animated: true)
    }

    func youTubeSearch() {
        let searchString = "\(song.artist) \(song.title)"

        let vc = YTSearchTableViewController(nibName:"YTSearchTableViewController", bundle:nil)
        vc.searchString = searchString

        navigationController?.pushViewController(vc, animated: true)
    }
}

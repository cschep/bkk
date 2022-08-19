//
//  SongDetailTableViewController.swift
//  Baby Ketten
//
//  Created by Christopher Schepman on 11/25/16.
//
//

import UIKit

class SongDetailHeaderView: UIView {
    let imageView: UIImageView = {
        return UIImageView(image: UIImage(named:"ketten_small_white.png"))
    }()
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 36)
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    let artistLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.translatesAutoresizingMaskIntoConstraints = false

        let labelStack = UIStackView(arrangedSubviews: [titleLabel, artistLabel])
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.axis = .vertical

        addSubview(imageView)
        addSubview(labelStack)

        let constraints = [
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.20),

            labelStack.topAnchor.constraint(equalTo: imageView.topAnchor),
            labelStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            labelStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

class SongDetailTableViewController: UITableViewController {
    let headerView: SongDetailHeaderView = {
        return SongDetailHeaderView()
    }()

    let song: Song

    init(song: Song) {
        self.song = song
        super.init(style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SongDetailCell")
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
    }

    func toggleFavorite() {
        song.toggleFavorite()
        // TODO REMOVE
        Favorites.shared.debugDump()

        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongDetailCell", for: indexPath)
        cell.accessoryType = .none

        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel!.text = "Favorite"

                if song.isFavorite {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
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

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                toggleFavorite()
            } else if (indexPath.row == 1) {
                artistSearch()
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                //TODO LYRICS SEARCH
                //[self lyricsSearch];
            } else if (indexPath.row == 1) {
                youTubeSearch()
            }

            // TODO SPOTIFY / APPLE MUSIC ??
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if (section == 1) {
            return "Searches will open a browser window." //still true?
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0) {
            headerView.titleLabel.text = song.title
            headerView.artistLabel.text = "- \(song.subtitle)"

            return headerView
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 116
        } else {
            return 24
        }
    }

    func artistSearch() {
        let vc = SongListTableViewController(style: .plain)
        vc.searchTerm = song.artist
        vc.searchBy = "artist"
        vc.random = false

        navigationController?.pushViewController(vc, animated: true)
    }

    func youTubeSearch() {
        let searchString = "\(song.artist) \(song.title)"

        let vc = YTSearchTableViewController()
        vc.searchString = searchString

        navigationController?.pushViewController(vc, animated: true)
    }
}

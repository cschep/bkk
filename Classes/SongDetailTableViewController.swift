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

        imageView.layer.borderColor = UIColor.red.cgColor
        imageView.layer.borderWidth = 2

        let labelStack = UIStackView(arrangedSubviews: [titleLabel, artistLabel])
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.axis = .vertical

        addSubview(imageView)
        addSubview(labelStack)

        let constraints = [
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.20),

            labelStack.topAnchor.constraint(equalTo: imageView.topAnchor),
            labelStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            labelStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
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
    var isFavorite: Bool = false
    var favoriteCell: UITableViewCell?

    init(song: Song) {
        self.song = song
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        setCheckmarkForFavorite()

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
            self.headerView.titleLabel.text = song.title;
            self.headerView.artistLabel.text = "-" + song.artist;

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

        let vc = YTSearchTableViewController()
        vc.searchString = searchString

        navigationController?.pushViewController(vc, animated: true)
    }
}

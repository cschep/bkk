//
//  SongDetailTableViewController.swift
//  Baby Ketten
//
//  Created by Christopher Schepman on 11/25/16.
//
//

import UIKit
import StoreKit

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
    let cloudServiceController = SKCloudServiceController()

    init(song: Song) {
        self.song = song
        super.init(style: .grouped)
        tableView.tintColor = .systemRed
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func toggleFavorite() {
        song.toggleFavorite()
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
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
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                cell.contentView.addSubview(logoImage(imageName: "apple_music_logo_red", leftMargin: 21.0, width: 150))
            } else if (indexPath.row == 1) {
                cell.contentView.addSubview(logoImage(imageName: "spotify_logo_green", leftMargin: 18.0, width: 120))
            }
        }

        return cell
    }

    func logoImage(imageName: String, leftMargin: CGFloat, width: CGFloat) -> UIImageView {
        let imageView = UIImageView(frame: .init(leftMargin, 3, width, 50))
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit

        return imageView
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
                lyricsSearch()
            } else if (indexPath.row == 1) {
                youTubeSearch()
            }


        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                appleMusicSearch()
            } else if (indexPath.row == 1) {
                spotifySearch()
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0) {
            headerView.titleLabel.text = song.title
            headerView.artistLabel.text = "- \(song.subtitle)"

            return headerView
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 116 : 24
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 2 ? 56 : 44
    }

    private func artistSearch() {
        Song.songs(for: song.artist, searchBy: "artist", isRandom: false) { songs in
            DispatchQueue.main.async { [weak self] in
                let vc = SongListTableViewController()
                vc.songs = songs
                vc.title = self?.song.artist
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    private func appleMusicSearch() {
        // TODO: this is fairly hideous and has no error checking (cromslor says to remind you that it works!)
        SKCloudServiceController.requestAuthorization { status in
            self.cloudServiceController.requestCapabilities { capabilities, capabilitiesError in
                self.cloudServiceController.requestStorefrontIdentifier { storeFrontIdentifier, storeFrontError in
                    guard let storeFrontIdentifier = storeFrontIdentifier, storeFrontError == nil else { return }
                    var identifier = storeFrontIdentifier.components(separatedBy: ",").first
                    identifier = identifier?.components(separatedBy: "-").first
                    let countryCode = self.countryCode(with: identifier)

                    var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
                    urlComponents.queryItems = [
                        URLQueryItem(name: "isStreamable", value: "true"),
                        URLQueryItem(name: "term", value: "\(self.song.artist) \(self.song.title)"),
                        URLQueryItem(name: "limit", value: "5"),
                        URLQueryItem(name: "country", value: countryCode),
                    ]

                    NetworkManager.GET(urlComponents.url!) { result in
                        if let result = result as? Dictionary<String, Any>,
                           let results = result["results"] as? Array<Dictionary<String, Any>>,
                           let first = results.first, let trackViewUrl = first["trackViewUrl"] {

                            let appleMusicDeepLink = "\(trackViewUrl)&mt=1&app=music"
                            UIApplication.shared.open(URL(string: appleMusicDeepLink)!)
                        }
                    }
                }
            }
        }
    }

    private func getSearchString(separator: String = "+") -> String {
        let searchString = "\(song.artist)\(separator)\(song.title)"
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove("&")
        allowedCharacterSet.remove("=")
        allowedCharacterSet.remove("?")

        return searchString.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? song.title
    }

    private func spotifySearch() {
        guard let spotifyURL = URL(string: "spotify:search:\(getSearchString())") else { return }
        UIApplication.shared.open(spotifyURL)
    }

    private func lyricsSearch() {
        if let url = URL(string: "http://www.songlyrics.com/index.php?section=search&searchW=\(getSearchString())&submit=Search&searchIn1=artist&searchIn2=album&searchIn3=song&searchIn4=lyrics") {
            UIApplication.shared.open(url)
        }
    }

    private func youTubeSearch() {
        let searchString = getSearchString(separator: " ")

        let vc = YTSearchTableViewController()
        vc.searchString = searchString

        navigationController?.pushViewController(vc, animated: true)
    }

    private func countryCode(with identifier: String?) -> String? {
        guard let identifier = identifier else { return nil }
        let plistURL = Bundle.main.url(forResource: "StorefrontCountries", withExtension: "plist")!
        if let countryCodeDictionary = try? NSDictionary(contentsOf: plistURL, error: ()) {
            return countryCodeDictionary.value(forKey: identifier) as? String
        }

        return nil
    }
}

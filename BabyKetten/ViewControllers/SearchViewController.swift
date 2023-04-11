//
//  SearchViewController.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/21/22.
//

import Foundation

class SearchViewController: UIViewController {
    let searchBar: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 32)
        tf.tintColor = .systemRed
        tf.placeholder = "search!"
        tf.autocapitalizationType = .none
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .search
        tf.clearButtonMode = .whileEditing
        return tf
    }()

    let bkkLogoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "bkklogobwtouchup"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    let searchToggle: UISegmentedControl = {
        // TODO: do we want to add brand here?
        let sc = UISegmentedControl(items: ["artist", "title"])
        sc.tintColor = .systemRed
        sc.selectedSegmentIndex = 0
        return sc
    }()

    let privateRoomSwitch: UISwitch = {
        let s = UISwitch()
        s.onTintColor = .systemRed
        return s
    }()

    let publicLabel: UILabel = {
        let l = UILabel()
        l.text = "public\nkaraoke"
        l.font = .systemFont(ofSize: 18, weight: .bold)
        l.numberOfLines = 2
        l.textAlignment = .center
        return l
    }()

    let privateLabel: UILabel = {
        let l = UILabel()
        l.text = "private\nroom"
        l.font = .systemFont(ofSize: 18, weight: .bold)
        l.numberOfLines = 2
        l.textAlignment = .center
        return l
    }()

    override func viewDidLoad() {
        searchBar.delegate = self

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        searchToggle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchToggle)

        bkkLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bkkLogoImageView)

        publicLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(publicLabel)

        privateRoomSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(privateRoomSwitch)

        privateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(privateLabel)

        let constraints = [
            bkkLogoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bkkLogoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            bkkLogoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bkkLogoImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            searchBar.topAnchor.constraint(equalTo: bkkLogoImageView.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 65),

            searchToggle.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            searchToggle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchToggle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            searchToggle.heightAnchor.constraint(equalToConstant: 35),

            publicLabel.topAnchor.constraint(equalTo: searchToggle.bottomAnchor, constant: 20),
            publicLabel.leadingAnchor.constraint(equalTo: searchToggle.leadingAnchor),
            publicLabel.widthAnchor.constraint(equalTo: searchToggle.widthAnchor, multiplier: 0.5),

            privateRoomSwitch.topAnchor.constraint(equalTo: searchToggle.bottomAnchor, constant: 22),
            privateRoomSwitch.centerXAnchor.constraint(equalTo: searchToggle.centerXAnchor),

            privateLabel.topAnchor.constraint(equalTo: searchToggle.bottomAnchor, constant: 20),
            privateLabel.trailingAnchor.constraint(equalTo: searchToggle.trailingAnchor),
            privateLabel.widthAnchor.constraint(equalTo: searchToggle.widthAnchor, multiplier: 0.5)
        ]

        NSLayoutConstraint.activate(constraints)

        title = "Search"

        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeRecognizer.direction = .down
        view.addGestureRecognizer(swipeRecognizer)

        super.viewDidLoad()
    }

    @objc
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(animated)
    }

    func search(isLive: Bool = false) {
        if let searchTerm = searchBar.text {

            // TODO: brand here?
            let scopes = ["artist", "title"]
            let searchBy = scopes[searchToggle.selectedSegmentIndex]

            Song.songs(for: searchTerm, searchBy: searchBy, isRandom: false, isPrivate: privateRoomSwitch.isOn, isLive: isLive) { songs in
                DispatchQueue.main.async { [weak self] in
                    let songListVC = SongListTableViewController()
                    songListVC.songs = songs
                    songListVC.title = searchTerm
                    songListVC.tableView.reloadData()
                    self?.navigationController?.navigationBar.isHidden = false
                    self?.navigationController?.pushViewController(songListVC, animated: true)
                }
            }
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
}

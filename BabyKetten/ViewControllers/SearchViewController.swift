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
        tf.translatesAutoresizingMaskIntoConstraints = false
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
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    let searchToggle: UISegmentedControl = {
        // TODO: do we want to add brand here?
        let sc = UISegmentedControl(items: ["artist", "title"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .systemRed
        sc.selectedSegmentIndex = 0
        return sc
    }()

    let privateRoomSwitch: UISwitch = {
        let s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.onTintColor = .systemRed
        return s
    }()

    let publicLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "public\nkaraoke"
        l.font = .systemFont(ofSize: 18, weight: .bold)
        l.numberOfLines = 2
        l.textAlignment = .center
        return l
    }()

    let privateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "private\nroom"
        l.font = .systemFont(ofSize: 18, weight: .bold)
        l.numberOfLines = 2
        l.textAlignment = .center
        return l
    }()

    // croms thinks this is so funny
    // have we always had to do this on apple or is this a hack around?
    let tapCatcher: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemBackground
        return v
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

        let tapper = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapper)

        let swipeRecognizer = UISwipeGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        swipeRecognizer.direction = .down
        view.addGestureRecognizer(swipeRecognizer)

        view.addSubview(tapCatcher)
        view.addSubview(searchBar)
        view.addSubview(searchToggle)
        view.addSubview(bkkLogoImageView)
        view.addSubview(publicLabel)
        view.addSubview(privateRoomSwitch)
        view.addSubview(privateLabel)

        let constraints = [
            tapCatcher.topAnchor.constraint(equalTo: view.topAnchor),
            tapCatcher.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tapCatcher.widthAnchor.constraint(equalTo: view.widthAnchor),
            tapCatcher.heightAnchor.constraint(equalTo: view.heightAnchor),

            bkkLogoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bkkLogoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bkkLogoImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            bkkLogoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),

            searchBar.topAnchor.constraint(equalTo: bkkLogoImageView.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            searchBar.heightAnchor.constraint(equalToConstant: 65),

            searchToggle.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            searchToggle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchToggle.widthAnchor.constraint(equalTo: searchBar.widthAnchor),
            searchToggle.heightAnchor.constraint(equalToConstant: 35),

            publicLabel.topAnchor.constraint(equalTo: searchToggle.bottomAnchor, constant: 20),
            publicLabel.leadingAnchor.constraint(equalTo: searchToggle.leadingAnchor),
            publicLabel.widthAnchor.constraint(equalTo: searchToggle.widthAnchor, multiplier: 0.5),
            publicLabel.heightAnchor.constraint(equalToConstant: 44),

            privateRoomSwitch.topAnchor.constraint(equalTo: searchToggle.bottomAnchor, constant: 22),
            privateRoomSwitch.centerXAnchor.constraint(equalTo: searchToggle.centerXAnchor),
            privateRoomSwitch.heightAnchor.constraint(equalToConstant: 44),

            privateLabel.topAnchor.constraint(equalTo: searchToggle.bottomAnchor, constant: 20),
            privateLabel.trailingAnchor.constraint(equalTo: searchToggle.trailingAnchor),
            privateLabel.widthAnchor.constraint(equalTo: searchToggle.widthAnchor, multiplier: 0.5),
            privateLabel.heightAnchor.constraint(equalToConstant: 44),
        ]

        NSLayoutConstraint.activate(constraints)

        title = "Search"
    }

    //TODO: push the vc to a loading state or loading state then push - the button can be hit multiple times and if the net is slow it's worse and worse
    func search(isLive: Bool = false) {
        // TODO: brand?
        guard let searchTerm = searchBar.text else { return }
        let scopes = ["artist", "title"]
        let searchBy = scopes[searchToggle.selectedSegmentIndex]

        let songListVC = SongListTableViewController()
        songListVC.searchTerm = searchTerm
        songListVC.searchBy = searchBy
        songListVC.isPrivate = privateRoomSwitch.isOn
        songListVC.startLoading()

        navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(songListVC, animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
}

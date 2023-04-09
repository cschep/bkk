//
//  SearchViewController.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/21/22.
//

import Foundation

class SearchViewController: UIViewController {
//    let buttonStack: UIStackView = {
//        var buttons: [UIButton] = []
//        for i in 0..<4 {
//            let b = UIButton(type: .custom)
//            b.setImage(UIImage(named: "ketten_small_white"), for: .normal)
//            buttons.append(b)
//        }
//
//        let topRow = UIStackView(arrangedSubviews: [buttons[0], buttons[1]])
//        topRow.axis = .horizontal
//        topRow.spacing = 10
//        topRow.distribution = .fillEqually
//
//        let bottomRow = UIStackView(arrangedSubviews: [buttons[2], buttons[3]])
//        bottomRow.axis = .horizontal
//        bottomRow.spacing = 10
//        bottomRow.distribution = .fillEqually
//
//        let sv = UIStackView(arrangedSubviews: [topRow, bottomRow])
//        sv.axis = .vertical
//        sv.distribution = .fillEqually
//        sv.spacing = 10
//
//        return sv
//    }()

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

    let latestMewsImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "latest_mews_taller"))
        return iv
    }()

    let searchToggle: UISegmentedControl = {
        // TODO: do we want to add brand here?
        let sc = UISegmentedControl(items: ["artist", "title"])
        sc.tintColor = .systemRed
        sc.selectedSegmentIndex = 0
        return sc
    }()

    override func viewDidLoad() {
        searchBar.delegate = self

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        searchToggle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchToggle)

//        buttonStack.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(buttonStack)

        latestMewsImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(latestMewsImageView)

        bkkLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bkkLogoImageView)

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

//            buttonStack.topAnchor.constraint(equalTo: searchToggle.bottomAnchor),
//            buttonStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            buttonStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            buttonStack.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),

            latestMewsImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            latestMewsImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            latestMewsImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),


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

            Song.songs(for: searchTerm, searchBy: searchBy, isRandom: false, isLive: isLive) { songs in
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

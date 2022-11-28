//
//  SearchViewController.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/21/22.
//

import Foundation

class SearchViewController: UIViewController {
    let buttonStack: UIStackView = {
        var buttons: [UIButton] = []
        for i in 0..<4 {
            let b = UIButton(type: .custom)
            b.setImage(UIImage(named: "ketten_small_white"), for: .normal)
            buttons.append(b)
        }

        let topRow = UIStackView(arrangedSubviews: [buttons[0], buttons[1]])
        topRow.axis = .horizontal
        topRow.spacing = 10
        topRow.distribution = .fillEqually

        let bottomRow = UIStackView(arrangedSubviews: [buttons[2], buttons[3]])
        bottomRow.axis = .horizontal
        bottomRow.spacing = 10
        bottomRow.distribution = .fillEqually

        let sv = UIStackView(arrangedSubviews: [topRow, bottomRow])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 10

        return sv
    }()

    let searchBar: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 16)
        tf.tintColor = .systemRed
        tf.backgroundColor = .systemBackground
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .search
        tf.clearButtonMode = .whileEditing
        return tf
    }()

    let searchToggle: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["artist", "title", "brand"])
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

        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)

        let constraints = [
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 45),

            searchToggle.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            searchToggle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            searchToggle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),

            buttonStack.topAnchor.constraint(equalTo: searchToggle.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            buttonStack.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
        ]

        NSLayoutConstraint.activate(constraints)

        title = "Search"

        super.viewDidLoad()
    }

    func search(isLive: Bool = false) {
        if let searchTerm = searchBar.text {

            let scopes = ["artist", "title", "brand"]
            let searchBy = scopes[searchToggle.selectedSegmentIndex]

            Song.songs(for: searchTerm, searchBy: searchBy, isRandom: false, isLive: isLive) { songs in
                DispatchQueue.main.async { [weak self] in
                    let songListVC = SongListTableViewController()
                    songListVC.songs = songs
                    songListVC.title = searchTerm
                    songListVC.tableView.reloadData()
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

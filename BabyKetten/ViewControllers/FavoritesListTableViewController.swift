//
//  FavoritesListTableViewController.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/10/22.
//

import UIKit

enum DisplayFavorite {
    case song(song: Song)
    case folder(folderName: String)
}

class FavoritesListTableViewController: UITableViewController {
    var onSongSelected: ((Song) -> Void)?
    var onFolderSelected: ((String) -> Void)?
    var onMoveRequested: (([Song], [String]) -> Void)?

    var currentFolder: String = FavoritesRootFolder.name
    var displayList: [DisplayFavorite] = Favorites.shared.displayFavorites()

    // cromslor loves this but I hate it
    // If we want to init the buttons and add the target at the same time e.g. self
    // then self has to be fully initalized - which requires super.init to be called
    // ... which requires the god damn buttons to be init'd
    // I've spent 15 minutes on this and I'm annoyed
    // cromlor is cackling maniacly chanting SHIP! SHIP!!
    var editButton: UIBarButtonItem!
    var addButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    var deleteButton: UIBarButtonItem!
    var moveButton: UIBarButtonItem!

    init() {
        super.init(style: .plain)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editFavesAction))
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAction))
        moveButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(moveAction))

        deleteButton.isEnabled = false
        moveButton.isEnabled = false

        navigationItem.rightBarButtonItem = editButton

        // if were in root, allow adding and show the default title
        if currentFolder == FavoritesRootFolder.name {
            navigationItem.title = "favorites!"
            navigationItem.leftBarButtonItem = addButton
        } else {
            navigationItem.title = currentFolder
        }

        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "FavoritesCell")
        tableView.register(Value1TableViewCell.self, forCellReuseIdentifier: "FolderCell")
        tableView.backgroundColor = .systemBackground

        refreshDisplayList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshDisplayList()
    }

    @objc
    func addAction() {
        let alertController = UIAlertController(title: "New Folder", message: "name of the new folder?", preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "create", style: .default, handler: { [weak self] _ in
            guard let folderName = alertController.textFields?[0].text else {
                return
            }
            Favorites.shared.add(folderName: folderName)
            self?.refreshDisplayList()
        }))

        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel))
        present(alertController, animated: true)
    }

    @objc
    func editFavesAction() {
        setEditing(true, animated: true)
        updateButtonsToMatchTableState()
    }

    @objc
    func cancelAction() {
        setEditing(false, animated: true)
        updateButtonsToMatchTableState()
    }

    @objc
    func deleteAction() {
        guard let selectedRows = tableView.indexPathsForSelectedRows, selectedRows.count > 0 else { return }

        let message = selectedRows.count == 1 ? "Are you sure you want to remove this item?" : "Are you sure you want to remove these items?"
        let actionSheet = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "OK", style: .destructive) { [weak self] _ in
            guard let selectedRows = self?.tableView.indexPathsForSelectedRows else { return }

            // go through the selected favorites
            for selectionIndex in selectedRows {
                self?.deleteFavorite(at: selectionIndex)
            }

            self?.refreshDisplayList()
            self?.setEditing(false, animated: true)
            self?.updateButtonsToMatchTableState()
        })
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel))

        present(actionSheet, animated: true)
    }

    func deleteFavorite(at indexPath: IndexPath) {
        switch displayList[indexPath.row] {
        case let .song(song):
            Favorites.shared.remove(song)
        case let .folder(folderName):
            Favorites.shared.remove(folderName: folderName)
        }
    }

    @objc
    func moveAction() {
        guard let selectedRows = tableView.indexPathsForSelectedRows else { return }
        let selectedSongs = selectedRows.compactMap { indexPath -> Song? in
            if case let .song(song) = displayList[indexPath.row] { return song }
            return nil
        }
        let folderList = ["🔙 to faves!"] + Favorites.shared.folders()
        onMoveRequested?(selectedSongs, folderList)
    }

    func updateButtonsToMatchTableState() {
        if tableView.isEditing {
            navigationItem.rightBarButtonItem = cancelButton
            navigationItem.setLeftBarButtonItems([deleteButton, moveButton], animated: true)

            // TODO: selected rows
            if let selectedRows = tableView.indexPathsForSelectedRows {
                let containsFolder = selectedRows.contains { indexPath in
                    switch displayList[indexPath.row] {
                    case .song:
                        return false
                    case .folder:
                        return true
                    }
                }

                moveButton.isEnabled = selectedRows.count > 0 && !containsFolder
                deleteButton.isEnabled = selectedRows.count > 0
            }
        } else {
            if currentFolder == FavoritesRootFolder.name {
                navigationItem.setLeftBarButtonItems([addButton], animated: true)
            } else {
                navigationItem.leftBarButtonItems = nil
            }

            editButton.isEnabled = Favorites.shared.favorites().count > 0
            navigationItem.rightBarButtonItem = editButton
        }
    }

    func refreshDisplayList() {
        displayList = Favorites.shared.displayFavorites(in: currentFolder)
        tableView.reloadData()
        updateButtonsToMatchTableState()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        tableView.allowsMultipleSelectionDuringEditing = editing
        super.setEditing(editing, animated: animated)
    }

    override func numberOfSections(in _: UITableView) -> Int {
        1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if displayList.count == 0 {
            tableView.setEmptyMessage("no favorites yet!")
        } else {
            tableView.restore()
        }

        return displayList.count
    }

    override func tableView(_: UITableView, willBeginEditingRowAt _: IndexPath) {
        editButton.isEnabled = false
    }

    override func tableView(_: UITableView, didEndEditingRowAt _: IndexPath?) {
        editButton.isEnabled = true
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            switch displayList[indexPath.row] {
            case let .song(song):
                onSongSelected?(song)
            case let .folder(folderName):
                onFolderSelected?(folderName)
            }
        } else {
            // while editing update the buttons depending on if anything is selected
            updateButtonsToMatchTableState()
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt _: IndexPath) {
        if tableView.isEditing {
            updateButtonsToMatchTableState()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch displayList[indexPath.row] {
        case let .song(song):
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath)
            cell.textLabel?.text = song.title
            cell.detailTextLabel?.text = song.artist
            cell.accessoryType = .disclosureIndicator
            return cell
        case let .folder(folderName):
            let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath)
            cell.textLabel?.text = String(format: "📁 %@", folderName)
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            let count = Favorites.shared.favorites(in: folderName).count
            cell.detailTextLabel?.text = String(format: "%i", count)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }

    override func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFavorite(at: indexPath)

            refreshDisplayList()
            updateButtonsToMatchTableState()
        }
    }
}

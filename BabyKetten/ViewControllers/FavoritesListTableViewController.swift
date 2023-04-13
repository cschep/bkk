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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        editButton = UIBarButtonItem(barButtonSystemItem:.edit, target:self, action:#selector(editFavesAction))
        addButton = UIBarButtonItem(barButtonSystemItem:.add, target:self, action:#selector(addAction))
        cancelButton = UIBarButtonItem(barButtonSystemItem:.cancel, target:self, action:#selector(cancelAction))
        deleteButton = UIBarButtonItem(barButtonSystemItem:.trash, target:self, action:#selector(deleteAction))
        moveButton = UIBarButtonItem(barButtonSystemItem:.action, target:self, action:#selector(moveAction))

        deleteButton.isEnabled = false
        moveButton.isEnabled = false

        navigationItem.rightBarButtonItem = editButton;

        // if were in root, allow adding and show the default title
        if currentFolder == FavoritesRootFolder.name {
            navigationItem.title = "Favorites!"
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
        let alertController = UIAlertController(title:"New Folder", message:"name of the new folder?", preferredStyle:.alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title:"create", style:.default, handler: { [weak self] action in
            guard let folderName = alertController.textFields?[0].text else {
                return
            }
            Favorites.shared.add(folderName: folderName)
            self?.refreshDisplayList()
        }))

        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel))
        self.present(alertController, animated: true)
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
        actionSheet.addAction(UIAlertAction(title: "OK", style: .destructive) { [weak self] action in
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
        case .song(let song):
            Favorites.shared.remove(song)
        case .folder(let folderName):
            Favorites.shared.remove(folderName: folderName)
        }
    }

    @objc
    func moveAction() {
        let vc = FolderPickerTableViewController()

        // the first item is so you can move a song out of a folder to the base level
        // there are no folders in folders
        // -- should this be handled by the picker? does it matter?
        vc.folderList = ["🔙 to faves!"] + Favorites.shared.folders()
        vc.delegate = self;

        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true)
    }

    func updateButtonsToMatchTableState() {
        if tableView.isEditing {
            navigationItem.rightBarButtonItem = self.cancelButton;
            navigationItem.setLeftBarButtonItems([self.deleteButton, self.moveButton], animated:true)

            //TODO: selected rows
            if let selectedRows = self.tableView.indexPathsForSelectedRows {
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
                navigationItem.leftBarButtonItems = nil;
            }

            self.editButton.isEnabled = Favorites.shared.favorites().count > 0;
            self.navigationItem.rightBarButtonItem = self.editButton;
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if displayList.count == 0 {
            self.tableView.setEmptyMessage("no favorites yet!")
        } else {
            self.tableView.restore()
        }

        return displayList.count
    }

    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        editButton.isEnabled = false
    }

    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        editButton.isEnabled = true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.tableView.isEditing {
            switch displayList[indexPath.row] {
            case .song(let song):
                let vc = SongDetailTableViewController(song: song)
                navigationController?.pushViewController(vc, animated: true)
            case .folder(let folderName):
                let vc = FavoritesListTableViewController()
                vc.currentFolder = folderName
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            // while editing update the buttons depending on if anything is selected
            updateButtonsToMatchTableState()
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateButtonsToMatchTableState()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch displayList[indexPath.row] {
        case .song(let song):
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath)
            cell.textLabel?.text = song.title
            cell.detailTextLabel?.text = song.artist
            cell.accessoryType = .disclosureIndicator
            return cell
        case .folder(let folderName):
            let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath)
            cell.textLabel?.text = String(format: "📁 %@", folderName)
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            let count = Favorites.shared.favorites(in: folderName).count
            cell.detailTextLabel?.text = String(format: "%i", count)
            cell.accessoryType = .disclosureIndicator;
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFavorite(at: indexPath)

            refreshDisplayList()
            updateButtonsToMatchTableState()
        }

    }
}

extension FavoritesListTableViewController: FolderPickerTableViewDelegate {
    func folderPicked(_ folderName: String?) {
        if let folderName = folderName {
            // nothing selected? bail!
            guard let selectedRows = tableView.indexPathsForSelectedRows else { return }

            // go through the selected favorites
            for selectionIndex in selectedRows {
                let favoriteToMove = displayList[selectionIndex.row]
                switch favoriteToMove {
                case .song(let song):
                    Favorites.shared.move(song: song, to: folderName)
                case .folder:
                    // you can't move folders
                    break
                }
            }

            refreshDisplayList()
            setEditing(false, animated: true)
            updateButtonsToMatchTableState()
        } else {
            setEditing(false, animated: true)
        }
    }
}

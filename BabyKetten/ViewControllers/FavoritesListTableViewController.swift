//
//  FavoritesListTableViewController.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/10/22.
//

import UIKit

class FavoritesListTableViewController: UITableViewController {
    var displayList: [Favorite] = []
    var currentFolder: String?

    // What are we doing here?
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

        if (currentFolder != nil) {
            navigationItem.title = currentFolder
        } else {
            navigationItem.title = "Favorites!"
            navigationItem.leftBarButtonItem = addButton
        }

        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "FavoritesCell")
        tableView.register(Value1TableViewCell.self, forCellReuseIdentifier: "FolderCell")
        tableView.backgroundColor = .systemBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshDisplayList()
    }

    @objc func addAction() {
        let alertController = UIAlertController(title:"New Folder", message:"name of the new folder?", preferredStyle:.alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title:"create", style:.default, handler: { [weak self] action in
            guard let folderTitle = alertController.textFields?[0].text else {
                return
            }
            Favorites.shared.add(.folder(title: folderTitle))
            self?.refreshDisplayList()
        }))

        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel))
        self.present(alertController, animated: true)
    }

    @objc func editFavesAction() {
        setEditing(true, animated: true)
        updateButtonsToMatchTableState()
    }

    @objc func cancelAction() {
        setEditing(false, animated: true)
        updateButtonsToMatchTableState()
    }
    @objc func deleteAction() {}
    @objc func moveAction() {
        let vc = FolderPickerTableViewController()
//        NSPredicate *pred = [NSPredicate predicateWithFormat:@"isFolder == %@", @"true"];
//
        var folderList = Favorites.shared.folders()
//        [folderList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//            return [[obj1 objectForKey:@"title"] compare:[obj2 objectForKey:@"title"] options:NSCaseInsensitiveSearch];
//        }];

        //[folderList insertObject:@{@"title": @"🔙 to faves!"} atIndex:0];
        vc.folderList = folderList
        vc.delegate = self;

//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        present(vc, animated: true)
    }

    func updateButtonsToMatchTableState() {
        if tableView.isEditing {
            navigationItem.rightBarButtonItem = self.cancelButton;
            navigationItem.setLeftBarButtonItems([self.deleteButton, self.moveButton], animated:true)

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
            if currentFolder != nil {
                navigationItem.leftBarButtonItems = nil;
            } else {
                navigationItem.setLeftBarButtonItems([addButton], animated: true)
            }

            self.editButton.isEnabled = self.displayList.count > 0;
            self.navigationItem.rightBarButtonItem = self.editButton;
        }
    }

    func refreshDisplayList() {
        displayList = Favorites.shared.favorites(in: currentFolder)

    //    [self.displayList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    //        //if either are folders, put them to the top, otherwise just alpha
    //        if ([[obj1 objectForKey:@"isFolder"] isEqualToString:@"true"] && ![[obj2 objectForKey:@"isFolder"] isEqualToString:@"true"]) {
    //            return NSOrderedAscending;
    //        } else if ([[obj2 objectForKey:@"isFolder"] isEqualToString:@"true"] && ![[obj1 objectForKey:@"isFolder"] isEqualToString:@"true"]) {
    //            return NSOrderedDescending;
    //        } else {
    //            return [[obj1 objectForKey:@"title"] compare:[obj2 objectForKey:@"title"] options:NSCaseInsensitiveSearch];
    //        }
    //    }];
    //

        tableView.reloadData()
    //    [self updateButtonsToMatchTableState];
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        tableView.allowsMultipleSelectionDuringEditing = editing
        super.setEditing(editing, animated: animated)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayList.count
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
                case .song(let song, _):
                    let vc = SongDetailTableViewController(song: song)
                    navigationController?.pushViewController(vc, animated: true)
                case .folder(title: let title):
                    let vc = FavoritesListTableViewController()
                    vc.currentFolder = title
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
        case .song(let song, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath)
            cell.textLabel?.text = song.title
            cell.detailTextLabel?.text = song.artist
            cell.accessoryType = .disclosureIndicator
            return cell
        case .folder(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath)
            cell.textLabel?.text = String(format: "📁 %@", title)
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            //NSPredicate *pred = [NSPredicate predicateWithFormat:@"folder == %@", [current objectForKey:@"title"]];
            //int count = (int)[[self.favorites filteredArrayUsingPredicate:pred] count];
            cell.detailTextLabel?.text = String(format: "%i", 0)
            cell.accessoryType = .disclosureIndicator;
            return cell
        }
    }
}

extension FavoritesListTableViewController: FolderPickerTableViewDelegate {
    func folderPicked(_ folderName: String!) {
        if folderName != nil {
//            NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
//
//            // Build an NSIndexSet of all the objects to move
//            NSMutableIndexSet *indicesOfItemsToMove = [NSMutableIndexSet new];
//            for (NSIndexPath *selectionIndex in selectedRows) {
//                //find it in favorites
//                id itemToMove = [self.displayList objectAtIndex:selectionIndex.row];
//                NSUInteger indexOfItemToMove = [self.favorites indexOfObjectIdenticalTo:itemToMove];
//
//                //change it
//                NSMutableDictionary *song = [[self.favorites objectAtIndex:indexOfItemToMove] mutableCopy];
//                if ([folderName isEqualToString:@""]) {
//                    [song removeObjectForKey:@"folder"];
//                } else {
//                    [song setObject:folderName forKey:@"folder"];
//                }
//                [self.favorites setObject:song atIndexedSubscript:indexOfItemToMove];
//
//                //then remove it from the displayList
//                [indicesOfItemsToMove addIndex:selectionIndex.row];
//            }
//
//            [self.displayList removeObjectsAtIndexes:indicesOfItemsToMove];
//
//            [self setEditing:NO animated:YES];
//            [self syncFavorites];
//            [self updateButtonsToMatchTableState];
        } else {
            setEditing(false, animated: true)
        }

    }


}


//- (void)deleteAction {
//    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
//    BOOL deleteSpecificRows = selectedRows.count > 0;
//    if (deleteSpecificRows) {
//        NSString *actionTitle;
//        if (([[self.tableView indexPathsForSelectedRows] count] == 1)) {
//            actionTitle = NSLocalizedString(@"Are you sure you want to remove this item?", @"");
//        } else {
//            actionTitle = NSLocalizedString(@"Are you sure you want to remove these items?", @"");
//        }
//
//        NSString *cancelTitle = NSLocalizedString(@"Cancel", @"Cancel title for item removal action");
//        NSString *okTitle = NSLocalizedString(@"OK", @"OK title for item removal action");
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
//
//            // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
//            NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
//            for (NSIndexPath *selectionIndex in selectedRows)
//            {
//                id removed = [self.displayList objectAtIndex:selectionIndex.row];
//
//                //if it's a folder, delete all songs in it as well
//                if ([[removed objectForKey:@"isFolder"] isEqualToString:@"true"]) {
//                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"folder == %@", [removed objectForKey:@"title"]];
//                    NSArray *songsToDelete = [self.favorites filteredArrayUsingPredicate:pred];
//
//                    [self.favorites removeObjectsInArray:songsToDelete];
//                }
//
//                [self.favorites removeObjectIdenticalTo:removed];
//
//                [indicesOfItemsToDelete addIndex:selectionIndex.row];
//            }
//
//            [self.displayList removeObjectsAtIndexes:indicesOfItemsToDelete];
//
//            [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationLeft];
//
//            [self setEditing:NO animated:YES];
//            [self syncFavorites];
//            [self updateButtonsToMatchTableState];
//        }];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
//
//        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:actionTitle preferredStyle:UIAlertControllerStyleActionSheet];
//        [actionSheet addAction:okAction];
//        [actionSheet addAction:cancelAction];
//
//        [self presentViewController:actionSheet animated:YES completion:nil];
//    }
//}
//

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        id removed = [self.displayList objectAtIndex:indexPath.row];
//
//        //if it's a folder, delete all songs in it as well
//        if ([[removed objectForKey:@"isFolder"] isEqualToString:@"true"]) {
//            NSPredicate *pred = [NSPredicate predicateWithFormat:@"folder == %@", [removed objectForKey:@"title"]];
//            NSArray *songsToDelete = [self.favorites filteredArrayUsingPredicate:pred];
//
//            [self.favorites removeObjectsInArray:songsToDelete];
//        }
//
//        [self.favorites removeObjectIdenticalTo:removed];
//    }
//
//    [self.displayList removeObjectAtIndex:indexPath.row];
//
//    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//
//    [self syncFavorites];
//    [self updateButtonsToMatchTableState];
//}


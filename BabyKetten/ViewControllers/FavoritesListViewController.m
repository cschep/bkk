//
//  FavoritesListViewController.m
//  Baby Ketten
//
//  Created by Christopher Schepman on 11/19/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import "FavoritesListViewController.h"
#import "FolderPickerTableViewController.h"
#import "baby_ketten-Swift.h"

@implementation FavoritesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editFavesAction)];
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
    self.deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAction)];
    self.moveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(moveAction)];

    self.deleteButton.enabled = NO;
    self.moveButton.enabled = NO;

    self.navigationItem.rightBarButtonItem = self.editButton;
    
    if (self.currentFolder) {
        self.navigationItem.title = self.currentFolder;
    } else {
        self.navigationItem.title = @"Favorites!";        
        self.navigationItem.leftBarButtonItem = self.addButton;
    }

    [self.tableView setBackgroundColor:[UIColor systemBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshDisplayList];
}

- (void)addAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New Folder" message:@"name of the new folder?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:nil];
    [alertController addAction:[UIAlertAction actionWithTitle:@"create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *folderTitle = [[alertController textFields][0] text];
        NSDictionary *folder = [NSDictionary dictionaryWithObjectsAndKeys:folderTitle, @"title", @"true", @"isFolder", nil];

        [self.favorites addObject:folder];

        [self syncFavorites];
        [self refreshDisplayList];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)moveAction {
    FolderPickerTableViewController *vc = [[FolderPickerTableViewController alloc] initWithStyle:UITableViewStylePlain];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"isFolder == %@", @"true"];

    NSMutableArray *folderList = [[self.favorites filteredArrayUsingPredicate:pred] mutableCopy];
    [folderList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 objectForKey:@"title"] compare:[obj2 objectForKey:@"title"] options:NSCaseInsensitiveSearch];
    }];

    [folderList insertObject:@{@"title": @"🔙 to faves!"} atIndex:0];
    vc.folderList = folderList;

    vc.delegate = self;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)editFavesAction {
    [self setEditing:YES animated:YES];
    [self updateButtonsToMatchTableState];
}

- (void)cancelAction {
    [self setEditing:NO animated:YES];
    [self updateButtonsToMatchTableState];
}

- (void)deleteAction {
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    BOOL deleteSpecificRows = selectedRows.count > 0;
    if (deleteSpecificRows) {
        NSString *actionTitle;
        if (([[self.tableView indexPathsForSelectedRows] count] == 1)) {
            actionTitle = NSLocalizedString(@"Are you sure you want to remove this item?", @"");
        } else {
            actionTitle = NSLocalizedString(@"Are you sure you want to remove these items?", @"");
        }
        
        NSString *cancelTitle = NSLocalizedString(@"Cancel", @"Cancel title for item removal action");
        NSString *okTitle = NSLocalizedString(@"OK", @"OK title for item removal action");
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];

            // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
            NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
            for (NSIndexPath *selectionIndex in selectedRows)
            {
                id removed = [self.displayList objectAtIndex:selectionIndex.row];

                //if it's a folder, delete all songs in it as well
                if ([[removed objectForKey:@"isFolder"] isEqualToString:@"true"]) {
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"folder == %@", [removed objectForKey:@"title"]];
                    NSArray *songsToDelete = [self.favorites filteredArrayUsingPredicate:pred];

                    [self.favorites removeObjectsInArray:songsToDelete];
                }

                [self.favorites removeObjectIdenticalTo:removed];

                [indicesOfItemsToDelete addIndex:selectionIndex.row];
            }

            [self.displayList removeObjectsAtIndexes:indicesOfItemsToDelete];

            [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationLeft];

            [self setEditing:NO animated:YES];
            [self syncFavorites];
            [self updateButtonsToMatchTableState];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];

        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:actionTitle preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheet addAction:okAction];
        [actionSheet addAction:cancelAction];

        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}

- (void)updateButtonsToMatchTableState {
    if (self.tableView.editing) {
        self.navigationItem.rightBarButtonItem = self.cancelButton;
        [self.navigationItem setLeftBarButtonItems:@[self.deleteButton, self.moveButton] animated:YES];

        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        BOOL okToMove = YES;
        for (NSIndexPath *selectionIndex in selectedRows) {
            if ([[[self.displayList objectAtIndex:selectionIndex.row] objectForKey:@"isFolder"] isEqualToString:@"true"]) {
                okToMove = NO;
            }
        }
        self.moveButton.enabled = selectedRows > 0 && okToMove;
        self.deleteButton.enabled = selectedRows > 0;
    } else {
        if (!self.currentFolder) {
            [self.navigationItem setLeftBarButtonItems:@[self.addButton] animated:YES];
        } else {
            self.navigationItem.leftBarButtonItems = nil;
        }

        self.editButton.enabled = self.displayList.count > 0;
        self.navigationItem.rightBarButtonItem = self.editButton;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id current = [self.displayList objectAtIndex:indexPath.row];
    UITableViewCell *cell;
    
    if (![current objectForKey:@"isFolder"]) {
        static NSString *CellIdentifier = @"Cell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [current objectForKey:@"title"];
        cell.detailTextLabel.text = [[self.displayList objectAtIndex:indexPath.row] objectForKey:@"artist"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        static NSString *FolderCellIdentifier = @"FolderCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:FolderCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:FolderCellIdentifier];
        }
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"folder == %@", [current objectForKey:@"title"]];
        int count = (int)[[self.favorites filteredArrayUsingPredicate:pred] count];
        
        cell.textLabel.text = [NSString stringWithFormat:@"📁 %@", [current objectForKey:@"title"]];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", count];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id removed = [self.displayList objectAtIndex:indexPath.row];
        
        //if it's a folder, delete all songs in it as well
        if ([[removed objectForKey:@"isFolder"] isEqualToString:@"true"]) {
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"folder == %@", [removed objectForKey:@"title"]];
            NSArray *songsToDelete = [self.favorites filteredArrayUsingPredicate:pred];
            
            [self.favorites removeObjectsInArray:songsToDelete];
        }
        
        [self.favorites removeObjectIdenticalTo:removed];
    }
    
    [self.displayList removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    [self syncFavorites];
    [self updateButtonsToMatchTableState];
}

- (void)refreshDisplayList {
    self.favorites = [[[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"] mutableCopy];

    if (self.currentFolder) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"folder == %@", self.currentFolder];
        self.displayList = [[self.favorites filteredArrayUsingPredicate:pred] mutableCopy];
    } else {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"folder == nil"];
        self.displayList = [[self.favorites filteredArrayUsingPredicate:pred] mutableCopy];
    }
    
    [self.displayList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        //if either are folders, put them to the top, otherwise just alpha
        if ([[obj1 objectForKey:@"isFolder"] isEqualToString:@"true"] && ![[obj2 objectForKey:@"isFolder"] isEqualToString:@"true"]) {
            return NSOrderedAscending;
        } else if ([[obj2 objectForKey:@"isFolder"] isEqualToString:@"true"] && ![[obj1 objectForKey:@"isFolder"] isEqualToString:@"true"]) {
            return NSOrderedDescending;
        } else {
            return [[obj1 objectForKey:@"title"] compare:[obj2 objectForKey:@"title"] options:NSCaseInsensitiveSearch];
        }
    }];
    
    [self.tableView reloadData];
    [self updateButtonsToMatchTableState];
}

- (void)syncFavorites {
    [[NSUserDefaults standardUserDefaults] setObject:self.favorites forKey:@"favorites"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.tableView.editing) {
        id tapped = [self.displayList objectAtIndex:indexPath.row];
        
        if ([[tapped objectForKey:@"isFolder"] isEqualToString:@"true"]) {
            FavoritesListViewController *vc = [[FavoritesListViewController alloc] initWithStyle:UITableViewStylePlain];
            vc.currentFolder = [tapped objectForKey:@"title"];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            NSString *title = [tapped objectForKey:@"title"];
            NSString *artist = [tapped objectForKey:@"artist"];

            SongDetailTableViewController *songDetailTableViewController = [[SongDetailTableViewController alloc] initWithArtist:artist title:title];
            [self.navigationController pushViewController:songDetailTableViewController animated:YES];
        }
    } else {
        // while editing update the buttons depending on if anything is selected
        [self updateButtonsToMatchTableState];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {
        [self updateButtonsToMatchTableState];
    }
}

- (void)folderPicked:(NSString *)folderName {
    if (folderName) {
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        
        // Build an NSIndexSet of all the objects to move
        NSMutableIndexSet *indicesOfItemsToMove = [NSMutableIndexSet new];
        for (NSIndexPath *selectionIndex in selectedRows) {
            //find it in favorites
            id itemToMove = [self.displayList objectAtIndex:selectionIndex.row];
            NSUInteger indexOfItemToMove = [self.favorites indexOfObjectIdenticalTo:itemToMove];

            //change it
            NSMutableDictionary *song = [[self.favorites objectAtIndex:indexOfItemToMove] mutableCopy];
            if ([folderName isEqualToString:@""]) {
                [song removeObjectForKey:@"folder"];
            } else {
                [song setObject:folderName forKey:@"folder"];
            }
            [self.favorites setObject:song atIndexedSubscript:indexOfItemToMove];
            
            //then remove it from the displayList
            [indicesOfItemsToMove addIndex:selectionIndex.row];
        }

        [self.displayList removeObjectsAtIndexes:indicesOfItemsToMove];
        
        [self setEditing:NO animated:YES];
        [self syncFavorites];
        [self updateButtonsToMatchTableState];
    } else {
        [self setEditing:NO animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    self.editButton.enabled = NO;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    self.editButton.enabled = YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    self.tableView.allowsMultipleSelectionDuringEditing = editing;
    [super setEditing:editing animated:animated];
}

@end


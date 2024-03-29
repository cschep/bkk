//
//  FolderPickerTableViewController.m
//  Baby Ketten
//
//  Created by Chris Schepman on 12/19/13.
//
//

#import "FolderPickerTableViewController.h"
#import "BabyKetten-Swift.h"

@interface FolderPickerTableViewController ()

@end

@implementation FolderPickerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Choose Folder";
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
}

- (void)doneAction {
    if (self.selectedFolder == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (self.selectedFolder.row == 0) {
        [self.delegate folderPicked:[FavoritesRootFolder name]];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSString *folderName = [self.folderList objectAtIndex:self.selectedFolder.row];
        [self.delegate folderPicked:folderName];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)cancelAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.folderList.count;
}

//CROMS fucking loves that this is in objective-c
//ha ha ha!
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FolderPickerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSString* title = [self.folderList objectAtIndex:indexPath.row];

    // first row is a move it up to base level thing
    if (indexPath.row == 0) {
        cell.textLabel.text = title;
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"📁 %@", title];
    }

    cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self.tableView cellForRowAtIndexPath:self.selectedFolder] setAccessoryType:UITableViewCellAccessoryNone];
    self.selectedFolder = indexPath;
    [[self.tableView cellForRowAtIndexPath:self.selectedFolder] setAccessoryType:UITableViewCellAccessoryCheckmark];
 
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

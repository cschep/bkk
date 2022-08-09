//
//  FolderPickerTableViewController.m
//  Baby Ketten
//
//  Created by Chris Schepman on 12/19/13.
//
//

#import "FolderPickerTableViewController.h"

@interface FolderPickerTableViewController ()

@end

@implementation FolderPickerTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Choose Folder";
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
}

- (void)doneAction
{   
    if(self.selectedFolder == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (self.selectedFolder.row == 0) {
        [self.delegate folderPicked:@""];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSString *folderName = [[self.folderList objectAtIndex:self.selectedFolder.row] objectForKey:@"title"];
        [self.delegate folderPicked:folderName];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.folderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FolderPickerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    id current = [self.folderList objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = [current objectForKey:@"title"];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"📁 %@", [current objectForKey:@"title"]];
    }

    cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [[self.tableView cellForRowAtIndexPath:self.selectedFolder] setAccessoryType:UITableViewCellAccessoryNone];
    self.selectedFolder = indexPath;
    [[self.tableView cellForRowAtIndexPath:self.selectedFolder] setAccessoryType:UITableViewCellAccessoryCheckmark];
 
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

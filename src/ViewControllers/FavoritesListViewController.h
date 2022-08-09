//
//  FavoritesListViewController.h
//  Baby Ketten
//
//  Created by Christopher Schepman on 11/19/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FolderPickerTableViewController.h"

@interface FavoritesListViewController : UITableViewController <UIAlertViewDelegate, UIActionSheetDelegate, FolderPickerTableViewDelegate>

@property (nonatomic, strong) NSMutableArray *favorites;
@property (nonatomic, strong) NSMutableArray *displayList;
@property (nonatomic, strong) NSString *currentFolder;

@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *deleteButton;
@property (nonatomic, strong) UIBarButtonItem *moveButton;

@end
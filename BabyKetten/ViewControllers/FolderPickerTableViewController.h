//
//  FolderPickerTableViewController.h
//  Baby Ketten
//
//  Created by Chris Schepman on 12/19/13.
//
//

#import <UIKit/UIKit.h>

@protocol FolderPickerTableViewDelegate;

@interface FolderPickerTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray<NSString *> *folderList;
@property (nonatomic, retain) NSIndexPath *selectedFolder;

@property (nonatomic, weak) id<FolderPickerTableViewDelegate> delegate;

@end

@protocol FolderPickerTableViewDelegate <NSObject>

- (void)folderPicked:(NSString *)folderName;

@end

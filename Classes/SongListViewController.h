//
//  SongListViewController.h
//  bkk
//
//  Created by Chris Schepman on 4/4/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface SongListViewController : UITableViewController <EGORefreshTableHeaderDelegate> {
	EGORefreshTableHeaderView *_refreshHeaderView;
	
    NSMutableArray *songList;
	NSString *searchTerm;
	NSString *searchBy;
	BOOL isRandom;
	UIActivityIndicatorView *activityIndicator;
}

- (id)initWithSearchTerm:(NSString *)searchTermIn SearchBy:(NSString *)searchByIn Random:(BOOL)_isRandom Style:(UITableViewStyle)style;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@property (strong) NSMutableArray *songList;
@property (strong) NSString *searchTerm;
@property (strong) NSString *searchBy;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property BOOL isRandom;

@end

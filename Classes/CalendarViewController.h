//
//  CalendarViewController.h
//  Baby Ketten
//
//  Created by Christopher Schepman on 6/7/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface CalendarViewController : UITableViewController <EGORefreshTableHeaderDelegate> {
	EGORefreshTableHeaderView *_refreshHeaderView;
    NSMutableArray *dateList;
}

@property (strong) NSMutableArray *dateList;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end

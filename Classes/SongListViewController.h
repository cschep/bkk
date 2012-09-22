//
//  SongListViewController.h
//  bkk
//
//  Created by Chris Schepman on 4/4/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongListViewController : UITableViewController {
	NSMutableArray *songList;
	NSString *searchTerm;
	NSString *searchBy;
	BOOL isRandom;
	UIActivityIndicatorView *activityIndicator;
}

- (id)initWithSearchTerm:(NSString *)searchTermIn SearchBy:(NSString *)searchByIn Random:(BOOL)_isRandom Style:(UITableViewStyle)style;

@property (strong) NSMutableArray *songList;
@property (strong) NSString *searchTerm;
@property (strong) NSString *searchBy;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property BOOL isRandom;

@end

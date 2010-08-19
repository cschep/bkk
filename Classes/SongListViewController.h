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

- (id)initWithStyle:(UITableViewStyle)style;
- (id)initWithSearchTerm:(NSString *)searchTermIn SearchBy:(NSString *)searchByIn Random:(BOOL)_isRandom Style:(UITableViewStyle)style;
- (void)loadSongs;
- (void)startLoadingSongs;

@property (retain) NSMutableArray *songList;
@property (retain) NSString *searchTerm;
@property (retain) NSString *searchBy;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property BOOL isRandom;

@end

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

}

- (id)initWithStyle:(UITableViewStyle)style;
- (id)initWithSearchTerm:(NSString *)searchTermIn SearchBy:(NSString *)searchByIn Style:(UITableViewStyle)style;
- (void)loadSongs;

@property (retain) NSMutableArray *songList;
@property (retain) NSString *searchTerm;
@property (retain) NSString *searchBy;

@end

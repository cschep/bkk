//
//  SongDetailViewController.h
//  bkk
//
//  Created by Chris Schepman on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface SongDetailViewController : UITableViewController {
	Song *song;
    BOOL isFavorite;
    
    IBOutlet UIView *headerView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *artistLabel;
}

- (id)initWithSong:(Song *)_song;

- (void)lyricsSearch;
- (void)artistSearch;
- (void)youTubeSearch;
- (void)toggleFavorite;
- (void)setCheckmarkForFavorite;

@property (nonatomic, retain) Song *song;

@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *artistLabel;

@end

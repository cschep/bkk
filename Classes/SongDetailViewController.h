//
//  SongDetailViewController.h
//  bkk
//
//  Created by Chris Schepman on 4/7/10.
//  Copyright Chris Schepman 2010. All rights reserved.
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

@property (nonatomic, strong) Song *song;

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *artistLabel;

@end

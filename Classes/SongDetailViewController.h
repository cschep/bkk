//
//  SongDetailViewController.h
//  bkk
//
//  Created by Chris Schepman on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "CoolButton.h"

@interface SongDetailViewController : UIViewController {
	Song *song;
    BOOL isFavorite;
    
    IBOutlet UILabel *songLabel;
    IBOutlet UILabel *artistLabel;
    
    IBOutlet CoolButton *favoriteButton;
    IBOutlet UIButton *lyricsButton;
    IBOutlet CoolButton *artistButton;
    IBOutlet UIButton *youtubeButton;
    
}

- (id)initWithSong:(Song *)_song;

- (IBAction)lyricsClicked:(id)sender;
- (IBAction)youTubeClicked:(id)sender;

@property (nonatomic, retain) Song *song;

@end

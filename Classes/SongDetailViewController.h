//
//  SongDetailViewController.h
//  bkk
//
//  Created by Chris Schepman on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface SongDetailViewController : UIViewController {
	Song *song;
}

- (id)initWithSong:(Song *)_song;

- (IBAction)lyricsClicked:(id)sender;
- (IBAction)youTubeClicked:(id)sender;

@property (retain) Song *song;

@end

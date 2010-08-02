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
	IBOutlet UITextView *lyricsView;
}

- (id)initWithSong:(Song *)songIn;

@property (retain) Song *song;

@end

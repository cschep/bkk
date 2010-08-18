//
//  LyricsWebViewController.h
//  Baby Ketten
//
//  Created by Christopher Schepman on 8/17/10.
//  Copyright 2010 schepsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface LyricsWebViewController : UIViewController {
	IBOutlet UIWebView *lyricsWebView;
	Song *song;
}

- (id)initWithSong:(Song *)_song;

@property (retain) Song *song;

@end

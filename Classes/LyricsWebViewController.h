//
//  LyricsWebViewController.h
//  Baby Ketten
//
//  Created by Christopher Schepman on 8/17/10.
//  Copyright 2010 schepsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface LyricsWebViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *lyricsWebView;
	IBOutlet UIBarButtonItem *backButton;
	IBOutlet UIBarButtonItem *forwardButton;
	Song *song;
	UIActivityIndicatorView *activityIndicator;
    
    NSURL *url;
}

- (id)initWithSong:(Song *)_song;

@property (retain) Song *song;
@property (nonatomic, retain) UIWebView *lyricsWebView;
@property (nonatomic, retain) UIBarButtonItem *backButton;
@property (nonatomic, retain) UIBarButtonItem *forwardButton;
@property (nonatomic, retain) NSURL *url;
@property (retain) UIActivityIndicatorView *activityIndicator;

@end

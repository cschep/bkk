//
//  SongDetailViewController.m
//  bkk
//
//  Created by Chris Schepman on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "SongDetailViewController.h"
#import "VCTitleCase.h"

@implementation SongDetailViewController

@synthesize song;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSong:(Song *)_song {
	if ((self = [super initWithNibName:@"SongDetailViewController" bundle:nil])) {
		self.song = _song;
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.title = [self.song.title titlecaseString];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)lyricsClicked:(id)sender {
    NSMutableString *searchString = [NSMutableString string];
    for (NSString *word in [song.artist componentsSeparatedByString:@" "]) {
        [searchString appendString:[NSString stringWithFormat:@"%@+", word]];
    }
    
    for (NSString *word in [song.title componentsSeparatedByString:@" "]) {
        [searchString appendString:[NSString stringWithFormat:@"%@+", word]];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.songlyrics.com/index.php?section=search&searchW=%@&submit=Search&searchIn1=artist&searchIn2=album&searchIn3=song&searchIn4=lyrics", searchString];

    NSString* escapedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSURL *url = [NSURL URLWithString:escapedUrlString];

    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)youTubeClicked:(id)sender {
    NSMutableString *searchString = [NSMutableString string];
    for (NSString *word in [song.artist componentsSeparatedByString:@" "]) {
        [searchString appendString:[NSString stringWithFormat:@"%@+", word]];
    }
    
    for (NSString *word in [song.title componentsSeparatedByString:@" "]) {
        [searchString appendString:[NSString stringWithFormat:@"%@+", word]];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://m.youtube.com/results?q=%@", searchString];
    
    NSString* escapedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSURL *url = [NSURL URLWithString:escapedUrlString];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (void)dealloc {
    [super dealloc];
}


@end

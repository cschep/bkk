//
//  LyricsWebViewController.m
//  Baby Ketten
//
//  Created by Christopher Schepman on 8/17/10.
//  Copyright 2010 schepsoft. All rights reserved.
//

#import "LyricsWebViewController.h"

@implementation LyricsWebViewController

@synthesize song;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (id)initWithSong:(Song *)_song {
	if (self = [super initWithNibName:@"LyricsWebViewController" bundle:nil]) {
		self.song = _song;
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString *urlString = [NSString stringWithFormat:@"http://lyrics.wikia.com/index.php?search=%@+%@&ns0=1&ns220=1&title=Special:Search&fulltext=Search&fulltext=Search", song.artist , song.title];
	NSString* escapedUrlString = [[urlString lowercaseString] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

	NSLog(@"%@", escapedUrlString);
	NSURL *url = [NSURL URLWithString:escapedUrlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[lyricsWebView loadRequest:request];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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


- (void)dealloc {
    [super dealloc];
}


@end

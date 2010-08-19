//
//  LyricsWebViewController.m
//  Baby Ketten
//
//  Created by Christopher Schepman on 8/17/10.
//  Copyright 2010 schepsoft. All rights reserved.
//

#import "LyricsWebViewController.h"
#import "VCTitleCase.h"

@implementation LyricsWebViewController

@synthesize song;
@synthesize lyricsWebView;
@synthesize backButton;
@synthesize forwardButton;
@synthesize activityIndicator;

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
	
	lyricsWebView.backgroundColor = [UIColor clearColor];
	
	//Create an instance of activity indicator view
	activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	
	//set the initial property
	[activityIndicator hidesWhenStopped];
	[activityIndicator startAnimating];
	
	//Create an instance of Bar button item with custome view which is of activity indicator
	UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	
	//Set the bar button the navigation bar
	[self navigationItem].rightBarButtonItem = barButton;
	
	//Memory clean up
	[activityIndicator release];
	[barButton release];
	
	self.title = @"Loading...";
	
	NSString *urlString = [NSString stringWithFormat:@"http://lyrics.wikia.com/index.php?search=%@+%@&ns0=1&ns220=1&title=Special:Search&fulltext=Search&fulltext=Search", song.artist , song.title];
	NSString* escapedUrlString = [[urlString lowercaseString] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

	NSLog(@"%@", escapedUrlString);
	NSURL *url = [NSURL URLWithString:escapedUrlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[lyricsWebView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	[activityIndicator startAnimating];
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	lyricsWebView.backgroundColor = [UIColor whiteColor];
	[activityIndicator  stopAnimating];
	self.title = [song.title titlecaseString];

	if ([webView canGoBack]) {
		backButton.enabled = YES;
	} else {
		backButton.enabled = NO;
	}
	
	if ([webView canGoForward]) {
		forwardButton.enabled = YES;
	} else {
		forwardButton.enabled = NO;
	}
	
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
	[lyricsWebView release];
}


@end

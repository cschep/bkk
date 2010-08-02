//
//  SongDetailViewController.m
//  bkk
//
//  Created by Chris Schepman on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "SongDetailViewController.h"
#import "Song.h"
#import "JSON.h"
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

- (id)initWithSong:(Song *)songIn {
	if (self = [super initWithNibName:@"SongDetailViewController" bundle:nil]) {
		self.song = songIn;
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	//Create an instance of activity indicator view
	UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	
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
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(foo)];
	//self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
	
	[NSThread detachNewThreadSelector:@selector(loadLyrics) toTarget:self withObject:nil];
}

/*
- (void)foo {
	NSLog(@"wrong clicked.");
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bad Lyrics!" message:@"Report these lyrics as incorrect?" delegate:nil cancelButtonTitle:@"Nope." otherButtonTitles:nil];
	[alert addButtonWithTitle:@"Yeah!"];
	[alert show];
	[alert release];
}
*/

- (void)loadLyrics {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *urlString = [NSString stringWithFormat:@"http://bkk.schepman.org/lyrics?songid=%@", self.song.songID];
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    id jsonValue = [jsonString JSONValue];
	
	NSString *lyrics = [[jsonValue objectAtIndex:0] objectForKey:@"lyrics"];
	
	if (lyrics == (NSString *)[NSNull null]) {
		lyrics = @"The lyrics for this song are not loaded yet, sorry!";
	} 
	
	self.song.lyrics = lyrics;
	
	[self performSelectorOnMainThread:@selector(didFinishLoadingLyrics) withObject:nil waitUntilDone:NO];
	[pool release];
}

- (void)didFinishLoadingLyrics {
	//[spinner stopAnimating];
	//self.title = [NSString stringWithFormat:@"Results for %@",[self searchTerm]];
	self.title = [self.song.title titlecaseString];
	
	[(UIActivityIndicatorView *)self.navigationItem.rightBarButtonItem.customView  stopAnimating];
	lyricsView.text =  self.song.lyrics;
	//[self.tableView reloadData];
    //[self.tableView flashScrollIndicators];
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

//
//  bkkViewController.m
//  bkk
//
//  Created by Chris Schepman on 4/3/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "bkkViewController.h"
#import "SongListViewController.h"
#import "JSON.h"

@implementation bkkViewController

@synthesize tweet;

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[textField resignFirstResponder];
	SongListViewController *songListViewController = [[SongListViewController alloc] initWithSearchTerm:theTextField.text SearchBy:[segmented titleForSegmentAtIndex:[segmented selectedSegmentIndex]] Random:NO Style:UITableViewStylePlain];
	songListViewController.title = @"Results";
	
	self.navigationController.navigationBar.hidden = NO;
	[self.navigationController pushViewController:songListViewController animated:YES];
	[songListViewController release];
	
	return YES;
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		[self kamikazeKetten];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	self.navigationController.navigationBar.hidden = YES;
    
    [super viewWillAppear:animated];
}

- (IBAction)loadWebPage {
    NSURL *url = [NSURL URLWithString:@"http://babyketten.com"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)kamikazeKetten {
	SongListViewController *songListViewController = [[SongListViewController alloc] initWithSearchTerm:@"none" SearchBy:@"none" Random:YES Style:UITableViewStylePlain];
	
	self.navigationController.navigationBar.hidden = NO;
	
	[UIView beginAnimations:@"animation" context:nil];
	[UIView setAnimationDuration:2.0];
	[self.navigationController pushViewController: songListViewController animated:NO]; 
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO]; 
	[UIView commitAnimations];
	
//	songListViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//	[self presentModalViewController:songListViewController animated:YES];
	
	//[self.navigationController pushViewController:songListViewController animated:YES];
	[songListViewController release];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];

    [self loadTweetInBackground];
}

- (void)loadTweetInBackground {
    [tweetSpinner startAnimating];
    latestTweet.text = @"";
    
    [NSThread detachNewThreadSelector:@selector(loadTweet) toTarget:self withObject:nil];    
}

- (void)loadTweet {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [NSThread sleepForTimeInterval:1];
    
	NSString *urlString = @"http://api.twitter.com/1/statuses/user_timeline.json?count=1&screen_name=babykettenOR";
	NSURL *url = [NSURL URLWithString:urlString];
	NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	
    if (jsonString != nil) {
        id jsonValue = [jsonString JSONValue];
        self.tweet = [[jsonValue objectAtIndex:0] valueForKey:@"text"];
    } else {
        self.tweet = @"Can't reach the internetz! Sing pretty!";
    }

	[self performSelectorOnMainThread:@selector(didFinishLoadingTweet) withObject:nil waitUntilDone:NO];
	[jsonString release];
	[pool release];
}

- (void)didFinishLoadingTweet {
	[tweetSpinner stopAnimating];
    latestTweet.text = tweet;
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

@end

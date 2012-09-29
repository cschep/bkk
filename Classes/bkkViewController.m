//
//  bkkViewController.m
//  bkk
//
//  Created by Chris Schepman on 4/3/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import "bkkViewController.h"
#import "SongListViewController.h"
#import "AFJSONRequestOperation.h"

@implementation bkkViewController

@synthesize tweet;

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchFor:textField.text
                 By:[segmented titleForSegmentAtIndex:[segmented selectedSegmentIndex]]  
        UsingRandom:NO];
	
	return YES;
}

- (void)searchFor:(NSString *)searchTerm By:(NSString *)searchBy UsingRandom:(BOOL)random  {
    SongListViewController *songListViewController = [[SongListViewController alloc] 
                                                      initWithSearchTerm:searchTerm 
                                                      SearchBy:searchBy 
                                                      Random:random 
                                                      Style:UITableViewStylePlain];
	songListViewController.title = @"Results";
	
	self.navigationController.navigationBar.hidden = NO;
	[self.navigationController pushViewController:songListViewController animated:YES];
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

- (void)viewWillAppear:(BOOL)animated {
	self.navigationController.navigationBar.hidden = YES;
    
    [super viewWillAppear:animated];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [[self view] addGestureRecognizer:recognizer];
    
    [self loadTweetInBackground];
    
    [super viewDidLoad];
}

- (void)loadTweetInBackground {
    NSString *urlString;
    NSString *city = [[NSUserDefaults standardUserDefaults] stringForKey:@"city"];
    if ([city isEqualToString:@"1"]) {
        urlString = @"http://api.twitter.com/1/statuses/user_timeline.json?count=1&screen_name=babykettenWA";
    } else {
        urlString = @"http://api.twitter.com/1/statuses/user_timeline.json?count=1&screen_name=babykettenOR";
    }
    
	NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //default UI
    [tweetSpinner startAnimating];
    latestTweet.text = @"";
    
    //update tweet
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.tweet = [[JSON objectAtIndex:0] valueForKey:@"text"];
        [tweetSpinner stopAnimating];
        latestTweet.text = tweet;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failed loading JSON.");
        [tweetSpinner stopAnimating];
        self.tweet = @"Can't reach the internetz! Sing pretty!";
        latestTweet.text = tweet;
    }];
    
    [operation start];
}

- (void)dismissKeyboard:(id)sender {
    [searchTextField resignFirstResponder];
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


@end

//
//  bkkViewController.m
//  bkk
//
//  Created by Chris Schepman on 4/3/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "bkkViewController.h"
#import "SongListViewController.h"

@implementation bkkViewController

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[textField resignFirstResponder];
	SongListViewController *songListViewController = [[SongListViewController alloc] initWithSearchTerm:theTextField.text SearchBy:[segmented titleForSegmentAtIndex:[segmented selectedSegmentIndex]] Random:NO Style:UITableViewStylePlain];
	songListViewController.title = @"Results";
	
	self.navigationController.navigationBar.hidden = NO;
	[self.navigationController pushViewController:songListViewController animated:YES];
	
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
	[self.navigationController pushViewController:songListViewController animated:YES];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
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

//
//  SongListViewController.m
//  bkk
//
//  Created by Chris Schepman on 4/4/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "SongListViewController.h"
#import "SongDetailViewController.h"
#import "LyricsWebViewController.h"
#import "JSON.h"
#import "Song.h"

@implementation SongListViewController

@synthesize songList;
@synthesize searchTerm;
@synthesize searchBy;
@synthesize isRandom;
@synthesize activityIndicator;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		//self.title = @"Results";
	}
    return self;
}

- (id)initWithSearchTerm:(NSString *)searchTermIn SearchBy:(NSString *)searchByIn Random:(BOOL)_isRandom Style:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		self.searchTerm = searchTermIn;
		self.searchBy = searchByIn;
		self.isRandom = _isRandom;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	//Create an instance of activity indicator view
	activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	//set the initial property
	[activityIndicator hidesWhenStopped];
	
	//Create an instance of Bar button item with custome view which is of activity indicator
	UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	
	//Set the bar button the navigation bar
	[self navigationItem].rightBarButtonItem = barButton;
	
	//Memory clean up
	[activityIndicator release];
	[barButton release];
	
	//start the load
	[self startLoadingSongs];
}

- (void)startLoadingSongs {
	//let the user know!
	[activityIndicator startAnimating];
	
	self.title = @"Loading...";
	[NSThread detachNewThreadSelector:@selector(loadSongs) toTarget:self withObject:nil];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		[self startLoadingSongs];
	}
}

- (void)loadSongs {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	self.songList = [[NSMutableArray alloc] init];
	
	NSString *urlString;
	if (isRandom) {
		urlString = [NSString stringWithFormat:@"http://bkk.schepman.org/random"];
	} else {
		urlString = [NSString stringWithFormat:@"http://bkk.schepman.org/json?search=%@&searchby=%@", self.searchTerm, self.searchBy];
	}
	
	NSString* escapedUrlString = [[urlString lowercaseString] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSURL *url = [NSURL URLWithString:escapedUrlString];
	
	NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	//NSString *jsonString = @"[{ \"artist\":\"fun.\",\"title\":\"Be Calm\"},{ \"artist\":\"fun.\",\"title\":\"benson hedges\"},{ \"artist\":\"vanilla ice\",\"title\":\"ice ice baby\"}]";
    id jsonValue = [jsonString JSONValue];
	
	for (NSDictionary *song in jsonValue) {
		Song *s = [[Song alloc] init];
		s.artist = [song valueForKey:@"artist"];
		s.title = [song valueForKey:@"title"];
		s.songID = [song valueForKey:@"id"];
		
		[songList addObject:s];
		//NSLog(@"%@", s.title);
		[s release];
	}
	//NSLog(@"%@", songList);	
	[jsonString release];
	
	[self performSelectorOnMainThread:@selector(didFinishLoadingSongs) withObject:nil waitUntilDone:NO];
	[pool release];
	
}


- (void)didFinishLoadingSongs {
	//[spinner stopAnimating];
	//self.title = [NSString stringWithFormat:@"Results for %@",[self searchTerm]];
	if ([songList count] == 0) {
		self.title = @"Not Found!";
	} else {
		if (isRandom) {
			self.title = @"Kamikaze!";
		} else {
			self.title = @"Results";
		}
	}

	[(UIActivityIndicatorView *)self.navigationItem.rightBarButtonItem.customView  stopAnimating];
	[self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [songList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [[songList objectAtIndex:indexPath.row] title];
	cell.detailTextLabel.text = [[songList objectAtIndex:indexPath.row] artist];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	//cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
 
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	/*
	SongDetailViewController *songDetailViewController = [[SongDetailViewController alloc] initWithSong:[songList objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:songDetailViewController animated:YES];
	[songDetailViewController release];
	*/

	LyricsWebViewController *lyricsWebViewController = [[LyricsWebViewController alloc] initWithSong:[songList objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:lyricsWebViewController animated:YES];
	[lyricsWebViewController release];
}




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;

}


- (void)dealloc {
    [songList release];
	[super dealloc];
}


@end


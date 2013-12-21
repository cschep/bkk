//
//  SongListViewController.m
//  bkk
//
//  Created by Chris Schepman on 4/4/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import "SongListViewController.h"
#import "SongDetailViewController.h"
#import "Song.h"
#import "AFJSONRequestOperation.h"

@implementation SongListViewController

@synthesize songList;
@synthesize searchTerm;
@synthesize searchBy;
@synthesize isRandom;
@synthesize activityIndicator;

- (id)initWithSearchTerm:(NSString *)searchTermIn SearchBy:(NSString *)searchByIn Random:(BOOL)_isRandom Style:(UITableViewStyle)style {
	if ((self = [super initWithStyle:style])) {
		self.searchTerm = searchTermIn;
		self.searchBy = searchByIn;
		self.isRandom = _isRandom;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];


	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	[self.activityIndicator hidesWhenStopped];
    self.activityIndicator.color = [UIColor blackColor];
	
	//Create an instance of Bar button item with custome view which is of activity indicator
	UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
	
	//Set the bar button the navigation bar
	[self navigationItem].rightBarButtonItem = barButton;
	
    [self loadSongs];
}

- (void)loadSongs {
	[self.activityIndicator startAnimating];
	self.title = @"Loading...";
    
    NSString *urlString;
    if (isRandom) {
        urlString = [NSString stringWithFormat:@"http://bkk.schepman.org/random"];
    } else {
        urlString = [NSString stringWithFormat:@"http://bkk.schepman.org/json?search=%@&searchby=%@", self.searchTerm, self.searchBy];
    }
    
    NSString* escapedUrlString = [[urlString lowercaseString] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
        JSONRequestOperationWithRequest:request
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                    [self loadSongsFromJSON:JSON];
                                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                    NSLog(@"Failed with error: %@", [error description]);
                                    self.title = @"Not Found!";
                                    [self.activityIndicator stopAnimating];
                                }];
    
    [operation start];
    
//    NSDictionary *song = [NSDictionary dictionaryWithObjectsAndKeys:@"baby", @"title", @"bieber, justin", @"artist", nil];
//    NSDictionary *song2 = [NSDictionary dictionaryWithObjectsAndKeys:@"song 2", @"title", @"blur", @"artist", nil];
//    [self loadSongsFromJSON:[NSArray arrayWithObjects:song, song2, nil]];
}

- (void)loadSongsFromJSON:(id)JSON {
	self.songList = [[NSMutableArray alloc] init];
	
	for (NSDictionary *song in JSON) {
		Song *s = [[Song alloc] init];
		s.artist = [song valueForKey:@"artist"];
		s.title = [song valueForKey:@"title"];
		s.songID = [song valueForKey:@"id"];
		
		[songList addObject:s];
	}
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [songList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[songList objectAtIndex:indexPath.row] title];
	cell.detailTextLabel.text = [[songList objectAtIndex:indexPath.row] artist];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SongDetailViewController *songDetailViewController = [[SongDetailViewController alloc] initWithSong:[songList objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:songDetailViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


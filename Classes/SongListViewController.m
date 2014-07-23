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
#import "AFHTTPRequestOperationManager.h"

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

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	[self.activityIndicator hidesWhenStopped];
    self.activityIndicator.color = [UIColor blackColor];
	
	//Create an instance of Bar button item with custome view which is of activity indicator
	UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
	
	//Set the bar button the navigation bar
	[self navigationItem].rightBarButtonItem = barButton;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(loadSongs)
             forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
	
    [self startLoadingUI];
    [self loadSongs];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)startLoadingUI {
    [self.activityIndicator startAnimating];
	self.navigationItem.title = @"Loading...";
}

- (void)stopLoadingUI {
    [self.activityIndicator stopAnimating];
    [self.refreshControl endRefreshing];
}

- (void)loadSongs {
    NSString *urlString;
    if (isRandom) {
        urlString = [NSString stringWithFormat:@"http://bkk.schepman.org/random"];
    } else {
        urlString = [NSString stringWithFormat:@"http://bkk.schepman.org/json?search=%@&searchby=%@", self.searchTerm, self.searchBy];
    }
    
    NSString* escapedUrlString = [[urlString lowercaseString] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:escapedUrlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self loadSongsFromJSON:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error fetching search results: %@", error);
        self.navigationItem.title = @"Not Found!";
        [self stopLoadingUI];
    }];
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
		self.navigationItem.title = @"Not Found!";
	} else {
		if (isRandom) {
			self.navigationItem.title = @"Kamikaze!";
		} else {
			self.navigationItem.title = @"Results";
		}
	}
    
    [self stopLoadingUI];
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


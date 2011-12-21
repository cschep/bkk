//
//  SongDetailViewController.m
//  bkk
//
//  Created by Chris Schepman on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "SongDetailViewController.h"
#import "VCTitleCase.h"
#import "LyricsWebViewController.h"
#import "bkkViewController.h"

@implementation SongDetailViewController

@synthesize song;
@synthesize headerView, titleLabel, artistLabel;

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
    
    self.title = @"Details";
    self.clearsSelectionOnViewWillAppear = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSArray *favorites = [[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"];
    NSDictionary *song_dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.song.artist, @"artist", self.song.title, @"title",  nil];
    
    isFavorite = [favorites containsObject:song_dict];
    [song_dict release];

    [self.tableView reloadData];
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

/* TableView Stuff */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    //menu stuff
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Favorite";

            if (isFavorite) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Artist Search";
        }  
    } else if (indexPath.section == 1) { 
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Lyrics Search";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"YouTube Search";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.row == 0) {
        [self toggleFavorite];
        
        isFavorite = !isFavorite;
        
        if (isFavorite) {
            [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
        }
        
    } else if (indexPath.row == 1) {
        [self artistSearch];
        
    } else if (indexPath.row == 2) {
        [self lyricsSearch];
        
    } else if (indexPath.row == 3) {
        [self youTubeSearch];
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return [NSString stringWithFormat:@"%@ - %@", song.artist, song.title];
    if (section == 1) {
        return @"Elsewhere..";
    } else {
        return nil;
    }
}
*/

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return @"these will take you to the browser!";
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        artistLabel.text = self.song.artist;
        titleLabel.text = self.song.title;  
        
        return headerView; 
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 116;
    } else {
        return 24;
    }
}

- (NSString *)getSearchString {
    NSMutableString *searchString = [NSMutableString string];
    for (NSString *word in [song.artist componentsSeparatedByString:@" "]) {
        [searchString appendString:[NSString stringWithFormat:@"%@+", word]];
    }
    
    for (NSString *word in [song.title componentsSeparatedByString:@" "]) {
        [searchString appendString:[NSString stringWithFormat:@"%@+", word]];
    }
    
    return searchString;
}

- (void)lyricsSearch {
    NSString *searchString = [self getSearchString];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.songlyrics.com/index.php?section=search&searchW=%@&submit=Search&searchIn1=artist&searchIn2=album&searchIn3=song&searchIn4=lyrics", searchString];

    NSString* escapedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSURL *url = [NSURL URLWithString:escapedUrlString];

    [[UIApplication sharedApplication] openURL:url];
}

- (void)youTubeSearch {
    NSString *searchString = [self getSearchString];
    
    NSString *urlString = [NSString stringWithFormat:@"http://m.youtube.com/results?q=%@", searchString];
    
    NSString* escapedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSURL *url = [NSURL URLWithString:escapedUrlString];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (void)artistSearch {
    [self.navigationController popToRootViewControllerAnimated:NO];
    bkkViewController *bkkVC = (bkkViewController *)[self.tabBarController.viewControllers objectAtIndex:0];
    [bkkVC searchFor:song.artist By:@"artist" UsingRandom:NO];  
}

- (void)toggleFavorite {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favorites = [[defaults arrayForKey:@"favorites"] mutableCopy];
    
    NSDictionary *song_dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.song.artist, @"artist", self.song.title, @"title", nil];
    
    if ([favorites containsObject:song_dict]) {
        //remove
        [favorites removeObject:song_dict];
    } else {
        //store
        [favorites addObject:song_dict];
    }

    [song_dict release];

    [defaults setObject:favorites forKey:@"favorites"];
    [defaults synchronize];
}

- (void)dealloc {
    [artistLabel release];
    [titleLabel release];
    [headerView release];

    [song release];

    [super dealloc];
}


@end

//
//  SongDetailViewController.m
//  bkk
//
//  Created by Chris Schepman on 4/7/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import "SongDetailViewController.h"
#import "SongListViewController.h"
#import "AFHTTPRequestOperationManager.h"

@implementation SongDetailViewController

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSong:(Song *)song {
	if ((self = [super initWithNibName:@"SongDetailViewController" bundle:nil])) {
		self.song = song;
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    self.title = @"Details";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    self.isFavorite = [self songInFavorites];
    
    [self.tableView reloadData];
    
    [self setCheckmarkForFavorite];
}

- (BOOL)songInFavorites {
    NSArray *favorites = [[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"];
    
    BOOL favorite = NO;
    for (id song in favorites) {
        if ([[song objectForKey:@"artist"] isEqualToString:self.song.artist] && [[song objectForKey:@"title"] isEqualToString:self.song.title]) {
            favorite = YES;
        }
    }

    return favorite;
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
    if (section == 0) {
        return 2;
    } else {
        return 3;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //menu stuff
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Favorite";

            if (self.isFavorite) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"More By This Artist";
        }  
    } else if (indexPath.section == 1) { 
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Genius App";
            
            if (!self.song.geniusID) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self checkGeniusForIDForCell:cell];
            }
            
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Lyrics Search";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"YouTube Search";
        }
    }
    
    return cell;
}

// cells lacking UITableViewCellAccessoryDisclosureIndicator will not be selectable
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    if (cell.accessoryType != UITableViewCellAccessoryDisclosureIndicator) {
//        return nil;
//    }
//    return indexPath;

    //genius button
    if (indexPath.section == 1 && indexPath.row == 0 && !self.song.geniusID) {
        return nil;
    }
    
    return indexPath;
}

// disabled cells will still have userinteraction enabled for their subviews
//- (void)setEnabled:(BOOL)enabled forTableViewCell:(UITableViewCell *)tableViewCell
//{
//    tableViewCell.accessoryType = (enabled) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
//    
//    // if you dont want the blue selection on tap, comment out the following line
//    tableViewCell.selectionStyle = (enabled) ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            [self toggleFavorite];
            
            self.isFavorite = !self.isFavorite;
            
            [self setCheckmarkForFavorite];            

        } else if (indexPath.row == 1) {
            [self artistSearch];
            
        } 
    
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            [self geniusSearch];
        } else if (indexPath.row == 1) {
            [self lyricsSearch];
        } else if (indexPath.row == 2) {
            [self youTubeSearch];
            
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return @"Searches will open a browser window.";
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        self.artistLabel.text = self.song.artist;
        self.titleLabel.text = self.song.title;
        
        return self.headerView;
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
    for (NSString *word in [self.song.artist componentsSeparatedByString:@" "]) {
        [searchString appendString:[NSString stringWithFormat:@"%@+", word]];
    }
    
    for (NSString *word in [self.song.title componentsSeparatedByString:@" "]) {
        [searchString appendString:[NSString stringWithFormat:@"%@+", word]];
    }
    
    return searchString;
}

- (void)geniusSearch {
    if (self.song.geniusID) {
        NSString *urlString = [NSString stringWithFormat:@"genius://songs/%@", self.song.geniusID];
        
        NSURL *myURL = [NSURL URLWithString:urlString];
        if ([[UIApplication sharedApplication] canOpenURL:myURL]) {
            [[UIApplication sharedApplication] openURL:myURL];
        } else {
            NSLog(@"genius not installed");
        }
    } else {
        NSLog(@"no geniusID");
    }
}

-(void)checkGeniusForIDForCell: (UITableViewCell *)cell {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0, 0, 24, 24);
    cell.accessoryView = spinner;
    [spinner startAnimating];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"queries": @[ @{@"title": self.song.title}, @{@"artist": self.song.artist} ] };
    
    [manager POST:@"http://api.genius.com/songs/lookup" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"trying to find %@ - %@ (artist - title) in genius", [[[parameters objectForKey:@"queries"] objectAtIndex:1] objectForKey:@"artist"], [[[parameters objectForKey:@"queries"] objectAtIndex:0] objectForKey:@"title"]);
        NSLog(@"success response: %@", responseObject);
        
        NSArray *hits = [[responseObject objectForKey:@"response"] objectForKey:@"hits"];
        
        if ([hits count] > 0) {
            NSString *geniusID =  [[[hits objectAtIndex:0] objectForKey:@"song"] objectForKey:@"id"];
            self.song.geniusID = geniusID;
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        } else {
            //try again with reversed artist?
            NSDictionary *parameters = @{@"queries": @[ @{@"title": self.song.title}, @{@"artist": [self.song reversedArtist]} ] };
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            [manager POST:@"http://api.genius.com/songs/lookup" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"trying to find %@ - %@ (artist - title) in genius", [[[parameters objectForKey:@"queries"] objectAtIndex:1] objectForKey:@"artist"], [[[parameters objectForKey:@"queries"] objectAtIndex:0] objectForKey:@"title"]);
                NSLog(@"success response: %@", responseObject);
                
                NSArray *hits = [[responseObject objectForKey:@"response"] objectForKey:@"hits"];
                
                if ([hits count] > 0) {
                    NSString *geniusID =  [[[hits objectAtIndex:0] objectForKey:@"song"] objectForKey:@"id"];
                    self.song.geniusID = geniusID;
                    cell.accessoryView = nil;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error fetching search results: %@", error);
                cell.accessoryType = UITableViewCellAccessoryNone;
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error fetching search results: %@", error);
        cell.accessoryType = UITableViewCellAccessoryNone;
    }];
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
    SongListViewController *artistSearchVC = [[SongListViewController alloc] 
                                                initWithSearchTerm:self.song.artist SearchBy:@"artist" Random:NO Style:UITableViewStylePlain];
    
    [self.navigationController pushViewController:artistSearchVC animated:YES];
}

- (void)toggleFavorite {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favorites = [[defaults arrayForKey:@"favorites"] mutableCopy];
    
    NSMutableArray *songsToDelete = [NSMutableArray array];
    if ([self songInFavorites]) {
        //remove
        for (id song in favorites) {
            if ([[song objectForKey:@"artist"] isEqualToString:self.song.artist] && [[song objectForKey:@"title"] isEqualToString:self.song.title]) {
                [songsToDelete addObject:song];
            }
        }
        
        [favorites removeObjectsInArray:songsToDelete];
    } else {
        //store
        NSDictionary *songDict = [[NSDictionary alloc] initWithObjectsAndKeys:self.song.artist, @"artist", self.song.title, @"title", nil];
        [favorites addObject:songDict];
    }


    [defaults setObject:favorites forKey:@"favorites"];
    [defaults synchronize];
}

- (void)setCheckmarkForFavorite {
    if (self.isFavorite) {
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
    }

}



@end

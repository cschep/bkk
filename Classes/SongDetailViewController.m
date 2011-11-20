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
    songLabel.text = self.song.title;
    artistLabel.text = self.song.artist;
    
    [favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
    [favoriteButton setTitle:@"Favorite \u2605" forState:UIControlStateSelected]; 
    
    [artistButton setButtonColor:[UIColor blackColor]];
    [favoriteButton setButtonColor:[UIColor blackColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    NSArray *favorites = [[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"];
    NSDictionary *song_dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.song.artist, @"artist", self.song.title, @"title",  nil];
    
    isFavorite = [favorites containsObject:song_dict];
    [song_dict release];
    
    [favoriteButton setSelected:isFavorite];
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

- (IBAction)lyricsClicked:(id)sender {
    NSString *searchString = [self getSearchString];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.songlyrics.com/index.php?section=search&searchW=%@&submit=Search&searchIn1=artist&searchIn2=album&searchIn3=song&searchIn4=lyrics", searchString];

    NSString* escapedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSURL *url = [NSURL URLWithString:escapedUrlString];

    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)youTubeClicked:(id)sender {
    NSString *searchString = [self getSearchString];
    
    NSString *urlString = [NSString stringWithFormat:@"http://m.youtube.com/results?q=%@", searchString];
    
    NSString* escapedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSURL *url = [NSURL URLWithString:escapedUrlString];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)artistSearch:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
    bkkViewController *bkkVC = (bkkViewController *)[self.tabBarController.viewControllers objectAtIndex:0];
    [bkkVC searchFor:song.artist By:@"artist" UsingRandom:NO];  
}

- (IBAction)toggleFavorite:(id)sender {

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
    
    [sender setSelected:(![sender isSelected])];

}

- (void)dealloc {
    [super dealloc];
}


@end

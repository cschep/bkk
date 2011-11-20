//
//  bkkAppDelegate.m
//  bkk
//
//  Created by Chris Schepman on 4/4/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "bkkAppDelegate.h"
#import "bkkViewController.h"
#import "CalendarViewController.h"
#import "TwitterViewController.h"
#import "FavoritesListViewController.h"
#import "KamikazeViewController.h"

@implementation bkkAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

	tabBarController = [[UITabBarController alloc] init];

    //searching
	mainViewController = [[bkkViewController alloc] initWithNibName:@"bkkViewController" bundle:nil];
	navControllerSearch = [[UINavigationController alloc] initWithRootViewController:mainViewController];
	[navControllerSearch navigationBar].hidden = YES;
	navControllerSearch.navigationBar.tintColor = [UIColor blackColor];
	navControllerSearch.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"search" image:[UIImage imageNamed:@"mic"] tag:1];

	//calendaring
	CalendarViewController *calendarViewController = [[CalendarViewController alloc] init];
	navControllerCalendar = [[UINavigationController alloc] initWithRootViewController:calendarViewController];
	navControllerCalendar.navigationBar.tintColor = [UIColor blackColor];
	navControllerCalendar.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"calendar" image:[UIImage imageNamed:@"calendar"]  tag:2];
	[calendarViewController release];

	//favorites list
	FavoritesListViewController *favoritesViewController = [[FavoritesListViewController alloc] initWithNibName:@"FavoritesListViewController" bundle:nil];
	navControllerFaves = [[UINavigationController alloc] initWithRootViewController:favoritesViewController];
    navControllerFaves.navigationBar.tintColor = [UIColor blackColor];
    navControllerFaves.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"faves" image:[UIImage imageNamed:@"inbox"] tag:3];
    [favoritesViewController release];
	
    //kamz
	KamikazeViewController *kamikazeView = [[KamikazeViewController alloc] initWithNibName:@"KamikazeViewController" bundle:nil];
	kamikazeView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"kamikaze!" image:[UIImage imageNamed:@"question"] tag:4];
    
	[tabBarController setViewControllers: [NSArray arrayWithObjects:navControllerSearch, navControllerCalendar, navControllerFaves, kamikazeView, nil]];
	[kamikazeView release];	

	
	[window setBackgroundColor:[UIColor blackColor]];
	[window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    
    //if there is no favorites array in defaults then create an empty one
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favorites = [defaults arrayForKey:@"favorites"];
    
    if (favorites == nil) {
        favorites = [[NSArray alloc] init];
        [defaults setObject:favorites forKey:@"favorites"];
        [favorites release];
    }
	
	return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //refresh the tweet dude.
    [mainViewController loadTweetInBackground];
}


- (void)dealloc {
    [mainViewController release];
    
	[navControllerSearch release];
	[navControllerCalendar release];
	
	[tabBarController release];
	[window release];
    [super dealloc];
}


@end

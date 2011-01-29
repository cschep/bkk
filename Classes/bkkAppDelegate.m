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
	
	//calendaring
	CalendarViewController *calendarViewController = [[CalendarViewController alloc] init];
	//calendarViewController.title = @"Calendar!";
	navControllerCalendar = [[UINavigationController alloc] initWithRootViewController:calendarViewController];
	navControllerCalendar.navigationBar.tintColor = [UIColor blackColor];
	navControllerCalendar.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"calendar" image:[UIImage imageNamed:@"calendar"]  tag:2];
	[calendarViewController release];

	//searching
	bkkViewController *bkkView = [[bkkViewController alloc] initWithNibName:@"bkkViewController" bundle:nil];
	navControllerSearch = [[UINavigationController alloc] initWithRootViewController:bkkView];
	[navControllerSearch navigationBar].hidden = YES;
	navControllerSearch.navigationBar.tintColor = [UIColor blackColor];
	navControllerSearch.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"search" image:[UIImage imageNamed:@"mic"] tag:1];
	[bkkView release];
	
	// twittering? newsing?
	/*
	TwitterViewController *twitterView = [[TwitterViewController alloc] initWithNibName:@"TwitterViewController" bundle:nil];
	twitterView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"tweets" image:[UIImage imageNamed:@"comment"] tag:4];
	*/
	 
	//kamz
	KamikazeViewController *kamikazeView = [[KamikazeViewController alloc] initWithNibName:@"KamikazeViewController" bundle:nil];
	kamikazeView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"kamikaze!" image:[UIImage imageNamed:@"question"] tag:4];
								
	//favorites list? all kinds'a lists?
	FavoritesListViewController *favoritesView = [[FavoritesListViewController alloc] initWithNibName:@"FavoritesListViewController" bundle:nil];
	favoritesView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"faves" image:[UIImage imageNamed:@"inbox"] tag:3];
	
	[tabBarController setViewControllers: [NSArray arrayWithObjects:navControllerSearch, navControllerCalendar, favoritesView, kamikazeView, nil]];
	[kamikazeView release];	
	[favoritesView release];
	
	
	[window setBackgroundColor:[UIColor blackColor]];
	[window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
	[navControllerSearch release];
	[navControllerCalendar release];
	
	[tabBarController release];
	[window release];
    [super dealloc];
}


@end

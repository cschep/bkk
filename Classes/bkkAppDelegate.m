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

@implementation bkkAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

	tabBarController = [[UITabBarController alloc] init];
	
	//searching
	bkkViewController *bkkView = [[bkkViewController alloc] initWithNibName:@"bkkViewController" bundle:nil];
	navControllerSearch = [[UINavigationController alloc] initWithRootViewController:bkkView];
	[navControllerSearch navigationBar].hidden = YES;
	navControllerSearch.navigationBar.tintColor = [UIColor blackColor];
	navControllerSearch.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:1];
	[bkkView release];

	//calendaring
	CalendarViewController *calendarViewController = [[CalendarViewController alloc] init];
	calendarViewController.title = @"Calendar!";
	navControllerCalendar = [[UINavigationController alloc] initWithRootViewController:calendarViewController];
	navControllerCalendar.navigationBar.tintColor = [UIColor blackColor];
	navControllerCalendar.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:2];
	[calendarViewController release];

		
	[tabBarController setViewControllers: [NSArray arrayWithObjects:navControllerSearch, navControllerCalendar, nil]];
	
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

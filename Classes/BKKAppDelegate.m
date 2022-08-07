//
//  bkkAppDelegate.m
//  bkk
//
//  Created by Chris Schepman on 4/4/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import "BKKAppDelegate.h"
#import "BKKViewController.h"
#import "CalendarViewController.h"
#import "FavoritesListViewController.h"
#import "KamikazeViewController.h"

@implementation BKKAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    self.tabBarController = [[UITabBarController alloc] init];
    [self.tabBarController.tabBar setTintColor:[UIColor redColor]];
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];

    self.mainViewController = [[BKKViewController alloc] init];
    
    self.navControllerSearch = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
	[self.navControllerSearch navigationBar].hidden = YES;
	self.navControllerSearch.navigationBar.tintColor = [UIColor redColor];
	self.navControllerSearch.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"search" image:[UIImage imageNamed:@"mic"] tag:1];

	CalendarViewController *calendarViewController = [[CalendarViewController alloc] init];
	self.navControllerCalendar = [[UINavigationController alloc] initWithRootViewController:calendarViewController];
	self.navControllerCalendar.navigationBar.tintColor = [UIColor redColor];
	self.navControllerCalendar.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"calendar" image:[UIImage imageNamed:@"calendar"]  tag:2];

	FavoritesListViewController *favoritesViewController = [[FavoritesListViewController alloc] initWithNibName:@"FavoritesListViewController" bundle:nil];
	self.navControllerFaves = [[UINavigationController alloc] initWithRootViewController:favoritesViewController];
    self.navControllerFaves.navigationBar.tintColor = [UIColor redColor];
    self.navControllerFaves.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"faves" image:[UIImage imageNamed:@"inbox"] tag:3];

	KamikazeViewController *kamikazeViewController = [[KamikazeViewController alloc] initWithNibName:@"KamikazeViewController" bundle:nil];
	self.navControllerKamikaze = [[UINavigationController alloc] initWithRootViewController:kamikazeViewController];
	self.navControllerKamikaze.navigationBar.tintColor = [UIColor redColor];
	self.navControllerKamikaze.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"kamikaze!" image:[UIImage imageNamed:@"question"] tag:4];
    
	[self.tabBarController setViewControllers: [NSArray arrayWithObjects:self.navControllerSearch, self.navControllerCalendar, self.navControllerFaves, self.navControllerKamikaze, nil]];
	
	[self.window setBackgroundColor:[UIColor blackColor]];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    //if there is no favorites array in defaults then create an empty one
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favorites = [defaults arrayForKey:@"favorites"];
    
    if (favorites == nil) {
        favorites = [[NSArray alloc] init];
        [defaults setObject:favorites forKey:@"favorites"];
    }
	
	return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self.mainViewController loadMessageInBackground];
}

@end

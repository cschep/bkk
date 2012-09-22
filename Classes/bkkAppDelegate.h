//
//  bkkAppDelegate.h
//  bkk
//
//  Created by Chris Schepman on 4/4/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bkkViewController.h"

@interface bkkAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
	
    UINavigationController *navControllerSearch;
	UINavigationController *navControllerCalendar;
    UINavigationController *navControllerFaves;
    UINavigationController *navControllerKamikaze;
	
    UITabBarController *tabBarController;
    
    bkkViewController *mainViewController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@end


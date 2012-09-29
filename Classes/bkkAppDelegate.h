//
//  bkkAppDelegate.h
//  bkk
//
//  Created by Chris Schepman on 4/4/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bkkViewController.h"

@interface bkkAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UINavigationController *navControllerSearch;
	UINavigationController *navControllerCalendar;
    UINavigationController *navControllerFaves;
    UINavigationController *navControllerKamikaze;
    
    bkkViewController *mainViewController;
}

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabBarController;

@end


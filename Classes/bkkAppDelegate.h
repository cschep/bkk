//
//  bkkAppDelegate.h
//  bkk
//
//  Created by Chris Schepman on 4/4/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bkkViewController.h"

@interface bkkAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabBarController;

@property (nonatomic, strong) UINavigationController *navControllerSearch;
@property (nonatomic, strong) bkkViewController *mainViewController;

@property (nonatomic, strong) UINavigationController *navControllerCalendar;
@property (nonatomic, strong) UINavigationController *navControllerFaves;
@property (nonatomic, strong) UINavigationController *navControllerKamikaze;

@end


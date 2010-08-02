//
//  bkkAppDelegate.h
//  bkk
//
//  Created by Chris Schepman on 4/4/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bkkAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
	UINavigationController *navControllerSearch;
	UINavigationController *navControllerCalendar;
	UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end


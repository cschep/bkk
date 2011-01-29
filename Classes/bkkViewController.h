//
//  bkkViewController.h
//  bkk
//
//  Created by Chris Schepman on 4/3/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bkkViewController : UIViewController {
	IBOutlet UITextField *textField;
	IBOutlet UISegmentedControl *segmented;
	IBOutlet UIButton *kamikazeButton;
	IBOutlet UILabel *latestTweet;
	NSString *tweet;
}

- (IBAction)loadWebPage;
- (IBAction)kamikazeKetten;

@property (retain) NSString *tweet;

@end


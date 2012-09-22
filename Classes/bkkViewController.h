//
//  bkkViewController.h
//  bkk
//
//  Created by Chris Schepman on 4/3/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bkkViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField *searchTextField;
	IBOutlet UISegmentedControl *segmented;
	IBOutlet UITextView *latestTweet;
    
    IBOutlet UIActivityIndicatorView *tweetSpinner;
	NSString *tweet;
}

- (void)loadTweetInBackground;
- (void)searchFor:(NSString *)searchTerm By:(NSString *)searchBy UsingRandom:(BOOL)random;
- (void)dismissKeyboard:(id)sender;

@property (strong) NSString *tweet;

@end


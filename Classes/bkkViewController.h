//
//  bkkViewController.h
//  bkk
//
//  Created by Chris Schepman on 4/3/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface bkkViewController : UIViewController <UITextViewDelegate, EGORefreshTableHeaderDelegate> {
	IBOutlet UITextField *searchTextField;
	IBOutlet UISegmentedControl *segmented;

	NSString *tweet;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
}

- (void)loadTweetInBackground;
- (void)searchFor:(NSString *)searchTerm By:(NSString *)searchBy UsingRandom:(BOOL)random;
- (void)dismissKeyboard:(id)sender;

@property (strong) NSString *tweet;
@property (nonatomic, strong) IBOutlet UITextView *tweetView;
@property IBOutlet UIActivityIndicatorView *tweetSpinner;

@end


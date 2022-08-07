//
//  bkkViewController.h
//  bkk
//
//  Created by Chris Schepman on 4/3/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface BKKViewController : UIViewController <UITextViewDelegate, EGORefreshTableHeaderDelegate>

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) UITextView *messageView;
@property (nonatomic, weak) UIActivityIndicatorView *messageLoadingSpinner;
@property (nonatomic, weak)	UISegmentedControl *segmented;
@property (nonatomic, weak)	UITextField *searchTextField;

@property (nonatomic, strong) EGORefreshTableHeaderView *refreshMessageView;

- (void)loadMessageInBackground;
- (void)searchFor:(NSString *)searchTerm By:(NSString *)searchBy UsingRandom:(BOOL)random;
- (void)dismissKeyboard:(id)sender;

@end


//
//  bkkViewController.h
//  bkk
//
//  Created by Chris Schepman on 4/3/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface bkkViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, EGORefreshTableHeaderDelegate>

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UITextView *messageView;
@property (nonatomic, strong) UIActivityIndicatorView *messageLoadingSpinner;
@property (nonatomic, strong) UISegmentedControl *segmented;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) EGORefreshTableHeaderView *refreshMessageView;

- (void)loadMessageInBackground;
- (void)searchFor:(NSString *)searchTerm By:(NSString *)searchBy UsingRandom:(BOOL)random;
- (void)dismissKeyboard:(id)sender;

@end


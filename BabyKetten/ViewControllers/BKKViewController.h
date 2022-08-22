//
//  bkkViewController.h
//  bkk
//
//  Created by Chris Schepman on 4/3/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKKViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextView *messageView;
@property (nonatomic, strong) UIActivityIndicatorView *messageLoadingSpinner;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UITextField *searchTextField;

- (void)loadMessageInBackground;
- (void)searchFor:(NSString *)searchTerm By:(NSString *)searchBy UsingRandom:(BOOL)random;

@end


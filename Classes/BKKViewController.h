//
//  bkkViewController.h
//  bkk
//
//  Created by Chris Schepman on 4/3/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKKViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) NSString *message;
@property (nonatomic, weak) IBOutlet UITextView *messageView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *messageLoadingSpinner;
@property (nonatomic, weak)	IBOutlet UISegmentedControl *segmented;
@property (nonatomic, weak)	IBOutlet UITextField *searchTextField;


- (void)loadMessageInBackground;
- (void)searchFor:(NSString *)searchTerm By:(NSString *)searchBy UsingRandom:(BOOL)random;
- (void)dismissKeyboard:(id)sender;

@end


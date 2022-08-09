//
//  bkkViewController.m
//  bkk
//
//  Created by Chris Schepman on 4/3/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import "BKKViewController.h"
#import "baby_ketten-Swift.h"

@implementation BKKViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchFor:textField.text
                 By:[self.segmentedControl titleForSegmentAtIndex:[self.segmentedControl selectedSegmentIndex]]
        UsingRandom:NO];
	
	return YES;
}

- (void)searchFor:(NSString *)searchTerm By:(NSString *)searchBy UsingRandom:(BOOL)random  {
    SongListTableViewController *vc = [[SongListTableViewController alloc]
                                          initWithStyle:UITableViewStylePlain];

    vc.searchTerm = searchTerm;
    vc.searchBy = searchBy;
    vc.random = random;
    
	vc.title = @"Results";
	
	self.navigationController.navigationBar.hidden = NO;
	[self.navigationController pushViewController:vc animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
	self.navigationController.navigationBar.hidden = YES;
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bkklogobwtouchup.jpg"]];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.imageView.layer.borderColor = [[UIColor redColor] CGColor];
//    self.imageView.layer.borderWidth = 2;

    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.searchTextField setDelegate:self];
    self.searchTextField.backgroundColor = [UIColor systemBackgroundColor];
    self.searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchTextField.placeholder = @"search!";
    self.searchTextField.font = [UIFont systemFontOfSize:24];
    self.searchTextField.tintColor = [UIColor redColor];
    self.searchTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    self.searchTextField.translatesAutoresizingMaskIntoConstraints = NO;

    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"artist", @"title"]];
    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.backgroundColor = [UIColor grayColor];

    [self.view addSubview:self.imageView];
    [self.view addSubview:self.searchTextField];
    [self.view addSubview:self.segmentedControl];

    NSArray *constraints = @[
        [self.imageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.imageView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [self.imageView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier: 0.15],
        [self.imageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],

        [self.searchTextField.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.searchTextField.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:10],
        [self.searchTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.searchTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],

        [self.segmentedControl.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.segmentedControl.topAnchor constraintEqualToAnchor:self.searchTextField.bottomAnchor constant:5],
        [self.segmentedControl.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.segmentedControl.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    ];

    [NSLayoutConstraint activateConstraints:constraints];

    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [[self view] addGestureRecognizer:recognizer];
    
    [self loadMessageInBackground];
    
    [super viewDidLoad];
}

- (void)loadMessageInBackground {
    NSString *twitterAccountName;
    NSString *city = [[NSUserDefaults standardUserDefaults] stringForKey:@"city"];
    if ([city isEqualToString:@"1"]) {
        twitterAccountName = @"babykettenwa";
    } else {
        twitterAccountName = @"babykettenor";
    }
    
    [self.messageLoadingSpinner startAnimating];
    self.messageView.text = @"";
    
//    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"pZE6rz7h4tT8ZU99FJKPA"
//                                                            consumerSecret:@"XXQC8FdFrf0r9OumRewXtZLPU2OsWXqDBxDRDSqM"];
//    
//    [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
//        
//        [twitter getUserTimelineWithScreenName:twitterAccountName
//                                         count:1
//                                  successBlock:^(NSArray *statuses) {
//                                      id latest = [statuses objectAtIndex:0];
////                                      NSString *text = [[latest objectForKey:@"text"] kv_decodeHTMLCharacterEntities];
////                                      self.message = text;
//                                      
//                                      self.message = [latest objectForKey:@"text"];
//
//                                      [self.messageLoadingSpinner stopAnimating];
//                                      self.messageView.text = self.message;
//                                      [self doneLoadingTableViewData];
//                                  } errorBlock:^(NSError *error) {
//                                      [self.messageLoadingSpinner stopAnimating];
//        
//                                      if ([self.message isEqualToString:@""]) {
//                                          self.message = @"Can't reach the internetz! Sing pretty!";
//                                      }
//
//                                      self.messageView.text = self.message;
//
//                                      [self doneLoadingTableViewData];
//                                  }];
//        
//    } errorBlock:^(NSError *error) {
//        [self.messageLoadingSpinner stopAnimating];
//        
//        if ([self.message isEqualToString:@""]) {
//            self.message = @"Can't reach the internetz! Sing pretty!";
//        }
//
//        self.messageView.text = self.message;
//        
//        [self doneLoadingTableViewData];
//    }];
}

- (void)dismissKeyboard:(id)sender {
    [self.searchTextField resignFirstResponder];
}

- (void)reloadTableViewDataSource{
    [self loadMessageInBackground];
}

@end

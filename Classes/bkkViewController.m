//
//  bkkViewController.m
//  bkk
//
//  Created by Chris Schepman on 4/3/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import "bkkViewController.h"
#import "SongListViewController.h"
#import "STTwitter.h"
#import "NSString+HTML.h"

@implementation bkkViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchFor:textField.text
                 By:[self.segmented titleForSegmentAtIndex:[self.segmented selectedSegmentIndex]]
        UsingRandom:NO];
	
	return YES;
}

- (void)searchFor:(NSString *)searchTerm By:(NSString *)searchBy UsingRandom:(BOOL)random  {
    SongListViewController *songListViewController = [[SongListViewController alloc] 
                                                          initWithSearchTerm:searchTerm
                                                                    SearchBy:searchBy
                                                                      Random:random
                                                                       Style:UITableViewStylePlain];
	songListViewController.title = @"Results";
	
	self.navigationController.navigationBar.hidden = NO;
	[self.navigationController pushViewController:songListViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [super viewWillAppear:animated];
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.view.backgroundColor = [UIColor blackColor];

    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bkk_cat_mews_background.png"]];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.backgroundImageView];

    self.headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bkklogobwtouchup.jpg"]];
    self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.headerImageView];

    self.messageView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.messageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageView.delegate = self;
    self.messageView.font = [UIFont systemFontOfSize:16];
    self.messageView.editable = NO;
    self.messageView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.messageView.tintColor = [UIColor redColor];
    self.messageView.userInteractionEnabled = YES;
    self.messageView.scrollEnabled = YES;
    self.messageView.clipsToBounds = YES;
    self.messageView.layer.cornerRadius = 15.0f;
    [self.view addSubview:self.messageView];

    self.messageLoadingSpinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    self.messageLoadingSpinner.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.messageLoadingSpinner];

    self.segmented = [[UISegmentedControl alloc] initWithItems:@[@"artist", @"title"]];
    self.segmented.translatesAutoresizingMaskIntoConstraints = NO;
    self.segmented.tintColor = [UIColor grayColor];
    self.segmented.selectedSegmentIndex = 0;
    [self.view addSubview:self.segmented];

    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.searchTextField.translatesAutoresizingMaskIntoConstraints = NO;

    self.searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchTextField.font = [UIFont systemFontOfSize:15];
    self.searchTextField.placeholder = @"search!";
    self.searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchTextField.keyboardType = UIKeyboardTypeDefault;
    self.searchTextField.returnKeyType = UIReturnKeyDone;
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.searchTextField.delegate = self;
    
    [self.view addSubview:self.searchTextField];
}

- (void)viewWillLayoutSubviews {
    NSLog(@"view will layout subviews called");

}

- (void)viewDidLoad {
    NSDictionary *views = @{
                            @"messageView": self.messageView,
                            @"messageLoadingSpinner": self.messageLoadingSpinner,
                            @"segmented": self.segmented,
                            @"searchTextField": self.searchTextField,
                            @"headerImageView": self.headerImageView,
                            @"backgroundImageView": self.backgroundImageView,
                            };

    NSMutableArray *allConstraints = [NSMutableArray array];

    NSArray *headerVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[headerImageView]"
                                                                                            options:nil
                                                                                            metrics:nil
                                                                                              views:views];

    [allConstraints addObjectsFromArray:headerVerticalConstraints];

    NSArray *headerHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[headerImageView]-15-|"
                                                                                   options:nil
                                                                                   metrics:nil
                                                                                     views:views];



    [allConstraints addObjectsFromArray:headerHorizontalConstraints];

    NSLayoutConstraint *headerAspectConstraint =[NSLayoutConstraint constraintWithItem:self.headerImageView
                                                                             attribute:NSLayoutAttributeWidth
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.headerImageView
                                                                             attribute:NSLayoutAttributeHeight
                                                                            multiplier:2.95/1.0  //aspect ratio: 2.95:1
                                                                              constant:0.0f];

    [allConstraints addObject:headerAspectConstraint];

    NSArray *searchTextVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[headerImageView]-[searchTextField]"
                                                                                     options:nil
                                                                                     metrics:nil
                                                                                       views:views];

    [allConstraints addObjectsFromArray:searchTextVerticalConstraints];

    NSArray *searchTextHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[searchTextField]-|"
                                                                                       options:nil
                                                                                       metrics:nil
                                                                                         views:views];

    [allConstraints addObjectsFromArray:searchTextHorizontalConstraints];

    NSArray *segmentedVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[searchTextField]-[segmented]"
                                                                                    options:nil
                                                                                    metrics:nil
                                                                                      views:views];

    [allConstraints addObjectsFromArray:segmentedVerticalConstraints];

    NSArray *segmentedHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[segmented]-|"
                                                                                      options:nil
                                                                                      metrics:nil
                                                                                        views:views];

    [allConstraints addObjectsFromArray:segmentedHorizontalConstraints];

    //TODO: tab bar in ios 8/9 is 49 pixels high. will this come back to bite me?
    NSArray *backgroundImageVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[backgroundImageView]-49-|"
                                                                                          options:nil
                                                                                          metrics:nil
                                                                                            views:views];

    [allConstraints addObjectsFromArray:backgroundImageVerticalConstraints];

    NSArray *backgroundImageHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[backgroundImageView]-|"
                                                                                            options:nil
                                                                                            metrics:nil
                                                                                              views:views];

    [allConstraints addObjectsFromArray:backgroundImageHorizontalConstraints];

    NSArray *messageViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[segmented]-60-[messageView]-200-|"
                                                                                      options:nil
                                                                                      metrics:nil
                                                                                        views:views];

    [allConstraints addObjectsFromArray:messageViewVerticalConstraints];

    NSArray *messageViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-200-[messageView(>=150)]-20-|"
                                                                                        options:nil
                                                                                        metrics:nil
                                                                                          views:views];

    [allConstraints addObjectsFromArray:messageViewHorizontalConstraints];

    [NSLayoutConstraint activateConstraints:allConstraints];


    NSLog(@"%@", NSStringFromCGRect(self.messageView.bounds));
    if (self.refreshMessageView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.messageView.bounds.size.height, self.messageView.frame.size.width, self.messageView.bounds.size.height) andSmallVersionEnabled:YES];
        view.delegate = self;
        [self.messageView addSubview:view];
        self.messageView.delegate = self;
        self.refreshMessageView = view;
    }
    
    //update the last update date
    [self.refreshMessageView refreshLastUpdatedDate];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:recognizer];
    
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
    
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"pZE6rz7h4tT8ZU99FJKPA"
                                                            consumerSecret:@"XXQC8FdFrf0r9OumRewXtZLPU2OsWXqDBxDRDSqM"];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        
        [twitter getUserTimelineWithScreenName:twitterAccountName
                                         count:1
                                  successBlock:^(NSArray *statuses) {
                                      id latest = [statuses objectAtIndex:0];
                                      NSString *text = [[latest objectForKey:@"text"] kv_decodeHTMLCharacterEntities];
                                      self.message = text;
                                      
                                      [self.messageLoadingSpinner stopAnimating];
                                      self.messageView.text = self.message;
                                      [self doneLoadingTableViewData];
                                  } errorBlock:^(NSError *error) {
                                      [self.messageLoadingSpinner stopAnimating];
        
                                      if ([self.message isEqualToString:@""]) {
                                          self.message = @"Can't reach the internetz! Sing pretty!";
                                      }

                                      self.messageView.text = self.message;

                                      [self doneLoadingTableViewData];
                                  }];
        
    } errorBlock:^(NSError *error) {
        [self.messageLoadingSpinner stopAnimating];
        
        if ([self.message isEqualToString:@""]) {
            self.message = @"Can't reach the internetz! Sing pretty!";
        }

        self.messageView.text = self.message;
        
        [self doneLoadingTableViewData];
    }];
}

- (void)dismissKeyboard:(id)sender {
    [self.searchTextField resignFirstResponder];
}

- (void)reloadTableViewDataSource{
    [self loadMessageInBackground];
}

- (void)doneLoadingTableViewData{
    [self.refreshMessageView egoRefreshScrollViewDataSourceDidFinishedLoading:self.messageView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.refreshMessageView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.refreshMessageView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return [self.messageLoadingSpinner isAnimating];
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date]; // should return date data source was last changed
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

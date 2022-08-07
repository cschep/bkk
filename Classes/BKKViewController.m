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
                 By:[self.segmented titleForSegmentAtIndex:[self.segmented selectedSegmentIndex]]
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
    [self.view addSubview:self.imageView];

    id constraints = @[
        [self.imageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.imageView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [self.imageView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier: 0.15],
        [self.imageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    ];

    [NSLayoutConstraint activateConstraints:constraints];

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

//
//  bkkViewController.m
//  bkk
//
//  Created by Chris Schepman on 4/3/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import "bkkViewController.h"
#import "SongListViewController.h"
#import "AFJSONRequestOperation.h"

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

- (void)viewDidLoad {
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
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [super viewDidLoad];
}

- (void)loadMessageInBackground {
    NSString *urlString;
    NSString *city = [[NSUserDefaults standardUserDefaults] stringForKey:@"city"];
    if ([city isEqualToString:@"1"]) {
        urlString = @"http://bkk.schepman.org/live_message_wa";
    } else {
        urlString = @"http://bkk.schepman.org/live_message_or";
    }
    
	NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //default UI
    [self.messageLoadingSpinner startAnimating];
    self.messageView.text = @"";
    
    //update tweet
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.message = [JSON objectForKey:@"message"];
        [self.messageLoadingSpinner stopAnimating];
        self.messageView.text = self.message;
        [self doneLoadingTableViewData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self.messageLoadingSpinner stopAnimating];
        self.message = @"Can't reach the internetz! Sing pretty!";
        self.messageView.text = self.message;
        [self doneLoadingTableViewData];
    }];
    
    [operation start];
}

- (void)dismissKeyboard:(id)sender {
    [self.searchTextField resignFirstResponder];
}

//
- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
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

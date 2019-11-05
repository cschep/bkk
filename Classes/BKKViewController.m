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
//    SongListViewController *songListViewController = [[SongListViewController alloc]
//                                                          initWithSearchTerm:searchTerm
//                                                                    SearchBy:searchBy
//                                                                      Random:random
//                                                                       Style:UITableViewStylePlain];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

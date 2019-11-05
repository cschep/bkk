//
//  SongDetailViewController.h
//  bkk
//
//  Created by Chris Schepman on 4/7/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SongDetailViewController : UITableViewController

- (id)initWithSong:(Song *)song;

@property (nonatomic, strong) Song *song;
@property BOOL isFavorite;

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *artistLabel;

@end

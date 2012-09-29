//
//  FavoritesListViewController.h
//  Baby Ketten
//
//  Created by Christopher Schepman on 11/19/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FavoritesListViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *favorites;

- (void)syncFavorites;

@end

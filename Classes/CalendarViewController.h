//
//  CalendarViewController.h
//  Baby Ketten
//
//  Created by Christopher Schepman on 6/7/10.
//  Copyright 2010 schepsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarViewController : UITableViewController {
	NSMutableArray *dateList;
}

@property (retain) NSMutableArray *dateList;

@end

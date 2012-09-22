//
//  CalendarViewController.m
//  Baby Ketten
//
//  Created by Christopher Schepman on 6/7/10.
//  Copyright 2010 schepsoft. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarDetailViewController.h"
#import "Date.h"
#import "AFJSONRequestOperation.h"

@implementation CalendarViewController

@synthesize dateList;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	//Create an instance of activity indicator view
	UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	
	//set the initial property
	[activityIndicator hidesWhenStopped];
	[activityIndicator startAnimating];
	
	//Create an instance of Bar button item with custome view which is of activity indicator
	UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	
	//Set the bar button the navigation bar
	[self navigationItem].rightBarButtonItem = barButton;
	
	self.navigationItem.title = @"Loading...";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[self getCalendarURL]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self loadDatesFromJSON:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        self.navigationItem.title = @"not found!";
        [(UIActivityIndicatorView *)self.navigationItem.rightBarButtonItem.customView  stopAnimating];
    }];
    
    [operation start];
}

- (NSURL *)getCalendarURL {
    NSDate *minDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*5]; //trailing 5 days...
	NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*30*3]; //next 3 months'ish
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
	[df setDateFormat:@"yyyy-MM-dd"]; //AHHHHH!
	NSString *urlString = [NSString stringWithFormat:@"http://www.google.com/calendar/feeds/9a434tnlm9mbo57r05rkodl6d0%%40group.calendar.google.com/public/full?alt=json&ctz=America/Los_Angeles&orderby=starttime&start-min=%@&start-max=%@&sortorder=a&singleevents=true", [df stringFromDate:minDate], [df stringFromDate:maxDate]];
    
	return [NSURL URLWithString:urlString];
}


- (void)loadDatesFromJSON:(id)JSON {
	dateList = [[NSMutableArray alloc] init];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	for (NSDictionary *entry in [[JSON valueForKey:@"feed"] valueForKey:@"entry"] ) {
		Date *d = [[Date alloc] init];
		d.title = [[entry valueForKey:@"title"] valueForKey:@"$t"];
		d.where = [NSString stringWithString:[[[entry valueForKey:@"gd$where"] valueForKey:@"valueString"] objectAtIndex:0]];
        d.description = [[entry valueForKey:@"content"] valueForKey:@"$t"];
        
		NSArray *when = [[entry valueForKey:@"gd$when"] valueForKey:@"startTime"];
		if (when) {
			[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"]; //.SSSZ"]; //2010-11-23T21:00:00.000-08:00
			
            //mother of hacks!
			NSDate *date = [dateFormatter dateFromString:[[[when objectAtIndex:0] componentsSeparatedByString:@"."] objectAtIndex:0]];
			[dateFormatter setDateFormat:@"EEE, MMM d"];
			d.when = [dateFormatter stringFromDate:date];;
		} else {
			d.when = @"no date!";
		}
		
		[dateList addObject:d];
        
        //done loading... sync up UI
        if ([dateList count] == 0) {
            self.navigationItem.title = @"not found!";
        } else {
            self.navigationItem.title = @"Calendar";
        }
        
        //TODO: really?
        [(UIActivityIndicatorView *)self.navigationItem.rightBarButtonItem.customView  stopAnimating];
        [self.tableView reloadData];
        [self.tableView flashScrollIndicators];
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return [dateList count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return 1;
}

- (UIView *)tableView:(UITableView *)tbl viewForHeaderInSection:(NSInteger)section
{
    //text things
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, MMM d"];

    //view
    UIView* sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tbl.bounds.size.width, 18)];
    sectionHead.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    sectionHead.userInteractionEnabled = YES;
    sectionHead.tag = section;
    
    UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlainTableViewSectionHeader.png"]];
    headerImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [sectionHead addSubview:headerImage];
    
    UILabel *sectionText = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tbl.bounds.size.width - 10, 18)];
    sectionText.backgroundColor = [UIColor clearColor];
    sectionText.shadowOffset = CGSizeMake(0,.6);
    sectionText.font = [UIFont boldSystemFontOfSize:18];
    sectionText.text = [[dateList objectAtIndex:section] when];
      
    if ([[dateFormatter stringFromDate:now] isEqualToString:[[dateList objectAtIndex:section] when]]) {
        sectionText.textColor = [UIColor colorWithRed:0.0 green:0.4 blue:0.9 alpha:1];
        sectionText.shadowColor = [UIColor whiteColor];
    } else {
        sectionText.textColor = [UIColor whiteColor];
        sectionText.shadowColor = [UIColor darkGrayColor];
    }


    [sectionHead addSubview:sectionText];
    
    return sectionHead;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
 	cell.textLabel.text = [[dateList objectAtIndex:indexPath.section] title];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
    Date *d = [dateList objectAtIndex:indexPath.section];
    if (![d.where isEqualToString:@""]) {
        CalendarDetailViewController *calendarDetailViewController = [[CalendarDetailViewController alloc] initWithDate:d];
        // ...
        // Pass the selected object to the new view controller.
        
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationDuration:1.0];
        [self.navigationController pushViewController:calendarDetailViewController animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO]; 
        [UIView commitAnimations];
        
        /*[self.navigationController pushViewController:calendarDetailViewController animated:YES];
         [calendarDetailViewController release];*/    
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:@"Not Sure Where?!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}




@end


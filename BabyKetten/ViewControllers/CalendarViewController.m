//
//  CalendarViewController.m
//  Baby Ketten
//
//  Created by Christopher Schepman on 6/7/10.
//  Copyright Chris Schepman 2010. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarDetailViewController.h"
#import "Date.h"
#import "BabyKetten-Swift.h"

@implementation CalendarViewController

NSString* const kSeattleCalendarId = @"b73eparqatr3h2160l7i298tas@group.calendar.google.com";
NSString* const kPortlandCalendarId = @"9a434tnlm9mbo57r05rkodl6d0@group.calendar.google.com";
NSString* const kGoogleCalendarAPIKey = @"AIzaSyC3RJ8eZ4AXCect-2RUdWMEUSdoJMOA0ds";

- (void)viewDidLoad {
    [super viewDidLoad];
    
	//Create an instance of activity indicator view
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.activityIndicator.color = [UIColor blackColor];
	
	//set the initial property
	[self.activityIndicator hidesWhenStopped];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(loadDates)
             forControlEvents:UIControlEventValueChanged];

    self.refreshControl = refreshControl;
    
	//Create an instance of Bar button item with custome view which is of activity indicator
	UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
	
	//Set the bar button the navigation bar
	[self navigationItem].rightBarButtonItem = barButton;
    
    [self startLoadingUI];
    [self loadDates];
}

- (void)startLoadingUI {
    [self.activityIndicator startAnimating];
	self.navigationItem.title = @"Loading...";
}

- (void)stopLoadingUI {
    [self.activityIndicator stopAnimating];
    [self.refreshControl endRefreshing];
}

- (void)loadDates {
    [NetworkManager GET:[self getCalendarURL] completionHandler:^(id JSON) {
        if (JSON != nil) {
            [self loadDatesFromJSON:JSON];
        } else {
            [self loadDatesFromJSON:@{}];
        }
    }];
}

- (NSString *)getCalendarURL {
    //TODO: figure out maybe there is a timezone thing happening, still seeing "before" events
    NSDate *now = [NSDate date];
	NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*30*3]; //next 3 months'ish

    //NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //[df setDateFormat:@"yyyy-MM-dd"]; //AHHHHH!
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    
    NSString *calendarId;
    NSString *city = [[NSUserDefaults standardUserDefaults] stringForKey:@"city"];
    if ([city isEqualToString:@"1"]) {
        calendarId = kSeattleCalendarId;
    } else {
        calendarId = kPortlandCalendarId;
    }
    
    NSString *urlFormat = @"https://www.googleapis.com/calendar/v3/calendars/%@/events?key=%@&singleEvents=true&orderBy=startTime&timeMin=%@&timeMax=%@&timeZone=America/Los_Angeles&fields=items(id,start,summary,status,location,description)";
    NSString *calendarUrl = [NSString stringWithFormat:urlFormat, calendarId, kGoogleCalendarAPIKey, [timeFormatter stringFromDate:now], [timeFormatter stringFromDate:maxDate]];

    return calendarUrl;
}


- (void)loadDatesFromJSON:(id)JSON {
	NSMutableArray *dateList = [[NSMutableArray alloc] init];

    static NSDateFormatter *dayFormatter, *timeFormatter, *printDateFormatter;
    if (!dayFormatter || !timeFormatter || !printDateFormatter) {
        dayFormatter = [[NSDateFormatter alloc] init];
        dayFormatter.dateFormat = @"yyyy-MM-dd";
        timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
        printDateFormatter = [[NSDateFormatter alloc] init];
        printDateFormatter.dateFormat = @"EEE, MMM d";
    }

	for (NSDictionary *entry in JSON[@"items"]) {
		Date *d = [[Date alloc] init];
		d.title = entry[@"summary"];
        d.where = entry[@"location"];
        d.description = entry[@"description"];

        NSDate *date;
        if (entry[@"start"][@"date"]) {
            date = [dayFormatter dateFromString:entry[@"start"][@"date"]];
            d.when = [printDateFormatter stringFromDate:date];
        } else if (entry[@"start"][@"dateTime"]) {
            date = [timeFormatter dateFromString:entry[@"start"][@"dateTime"]];
            d.when = [printDateFormatter stringFromDate:date];
        } else {
            d.when = @"no date!";
        }
        
		[dateList addObject:d];
	}
    self.dateList = dateList;

    dispatch_async(dispatch_get_main_queue(), ^{
        if ([dateList count] == 0) {
            self.navigationItem.title = @"Not Found!";
        } else {
            self.navigationItem.title = @"Calendar";
        }

        [self stopLoadingUI];
        [self.tableView reloadData];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return [self.dateList count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.dateList objectAtIndex:section] when];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.dateList objectAtIndex:indexPath.section] title];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Date *d = [self.dateList objectAtIndex:indexPath.section];
    if (![d.where isEqualToString:@""]) {
        CalendarDetailViewController *calendarDetailViewController = [[CalendarDetailViewController alloc] initWithDate:d];
        [self.navigationController pushViewController:calendarDetailViewController animated:YES];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"title" message:@"Not Sure WHere?!" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end


//
//  CalendarViewController.m
//  Baby Ketten
//
//  Created by Christopher Schepman on 6/7/10.
//  Copyright 2010 schepsoft. All rights reserved.
//

#import "CalendarViewController.h"
#import "JSON.h"
#import "Date.h"


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
	
	//Memory clean up
	[activityIndicator release];
	[barButton release];
	
	self.navigationItem.title = @"Loading...";
	
	[NSThread detachNewThreadSelector:@selector(loadDates) toTarget:self withObject:nil];
}

- (void)loadDates {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	self.dateList = [[NSMutableArray alloc] init];
	
	//NSString *urlString = [NSString stringWithFormat:@"http://localhost:4567/json?search=%@&searchby=%@", self.searchTerm, self.searchBy];
	//NSString *urlString = [NSString stringWithFormat:@"http://bkk.schepman.org/json?search=%@&searchby=%@", self.searchTerm, self.searchBy];
	//NSString* escapedUrlString = [[urlString lowercaseString] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

	NSDate *minDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*5]; //trailing 5 days...
	NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*30*3]; //next 3 months'ish
	NSDateFormatter *df = [[NSDateFormatter alloc] init];

	[df setDateFormat:@"yyyy-MM-dd"]; //AHHHHH!
	NSString *urlString = [NSString stringWithFormat:@"http://www.google.com/calendar/feeds/9a434tnlm9mbo57r05rkodl6d0%%40group.calendar.google.com/public/full?alt=json&ctz=America/Los_Angeles&orderby=starttime&start-min=%@&start-max=%@&sortorder=a&singleevents=true", [df stringFromDate:minDate], [df stringFromDate:maxDate]];
	//NSLog(urlString);
	[df release];

	NSURL *url = [NSURL URLWithString:urlString];
	NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	id jsonValue = [jsonString JSONValue];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	for (NSDictionary *entry in [[jsonValue valueForKey:@"feed"] valueForKey:@"entry"] ) {
		Date *d = [[Date alloc] init];
		d.title = [[entry valueForKey:@"title"] valueForKey:@"$t"];
		
		NSArray *when = [[entry valueForKey:@"gd$when"] valueForKey:@"startTime"];
		if (when) {
			[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"]; //.SSSZ"]; //2010-11-23T21:00:00.000-08:00
			//mother of hacks!
			NSDate *date = [dateFormatter dateFromString:[[[when objectAtIndex:0] componentsSeparatedByString:@"."] objectAtIndex:0]];
			[dateFormatter setDateFormat:@"EEEE, MMM d"];
			d.when = [dateFormatter stringFromDate:date];;
		} else {
			d.when = @"no date!";
		}
		
		[dateList addObject:d];
		NSLog(@"title: %@", d.title);
		NSLog(@"when:  %@", d.when);
		NSLog(@"$t:    %@", [[entry valueForKey:@"content"] valueForKey:@"$t"]);
		[d release];
	}
	[dateFormatter release];
	[jsonString release];
	
	[self performSelectorOnMainThread:@selector(didFinishLoadingDates) withObject:nil waitUntilDone:NO];
	[pool release];
}

- (void)didFinishLoadingDates {
	if ([dateList count] == 0) {
		self.navigationItem.title = @"not found!";
	} else {
		self.navigationItem.title = @"Calendar";
	}
	
	[(UIActivityIndicatorView *)self.navigationItem.rightBarButtonItem.customView  stopAnimating];
	[self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	//why is when nil???
	
	return [[dateList objectAtIndex:section] when];
	//return @"test title";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	/*
	if ([[dateList objectAtIndex:indexPath.section] when] != nil) {
		cell.textLabel.text = [[dateList objectAtIndex:indexPath.section] when];
	} else {
		cell.textLabel.text = @"woops!";
	}
	*/
	
	//cell.textLabel.text = [[dateList objectAtIndex:indexPath.section] when];
	cell.textLabel.text = [[dateList objectAtIndex:indexPath.section] title];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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


- (void)dealloc {
    [super dealloc];
}


@end


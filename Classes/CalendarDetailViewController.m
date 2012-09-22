//
//  CalendarDetailViewController.m
//  Baby Ketten
//
//  Created by Christopher Schepman on 3/27/11.
//  Copyright 2011 Schepsoft. All rights reserved.
//

#import "CalendarDetailViewController.h"
#import "Date.h"

@implementation CalendarDetailViewController

@synthesize date, descText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDate:(Date *)_date {
	if ((self = [super initWithNibName:@"CalendarDetailViewController" bundle:nil])) {
		self.date = _date;
	}
	return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    mapView.userInteractionEnabled = NO;
    
//    titleLabel.text = date.title;
    self.title = date.title;
    
    //NSLog(@"%@", date.description);
    descText.text = date.description;
    
    
	// Forward geocode! - "pdx" makes the airport come up.. hrm..
    NSString *searchTerm = [self.date.where stringByReplacingOccurrencesOfString:@"pdx" withString:@"Portland, OR"];
    searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@"the woods 6637 milwauke ave" withString:@"6637 SE Milwaukie Avenue"];    
    //NSLog(@"searching for term: %@", searchTerm);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - map methods

- (MKAnnotationView *)mapView:(MKMapView *)sender viewForAnnotation:(id <MKAnnotation>)annotation
{
//    MKAnnotationView *aView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"foo"] autorelease];
//    aView.image = [UIImage imageNamed:@"jumpinkettenicon.png"];
//    aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    
//    return aView;
    
    MKPinAnnotationView *aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"foo"];
    aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    aView.canShowCallout = YES;
    aView.animatesDrop = YES;

    
    return aView;
}

- (void)mapView:(MKMapView *)sender annotationView:(MKAnnotationView *)aView calloutAccessoryControlTapped:(UIControl *)control
{
    //[(FindARetailerViewController *)top retailerSelected:aView.annotation];
    NSLog(@"%@", aView.annotation.title);
    
    NSString* addr = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=Current Location&daddr=%f,%f",aView.annotation.coordinate.latitude,aView.annotation.coordinate.longitude];
    NSLog(@"%@", addr);
    NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - BSForwardGeocode


//- (void)forwardGeocodingDidSucceed:(BSForwardGeocoder *)geocoder withResults:(NSArray *)results
//{
//	if(forwardGeocoder.status == G_GEO_SUCCESS)
//	{
//		if([forwardGeocoder.results count] == 1)
//		{
//			BSKmlResult *place = [forwardGeocoder.results objectAtIndex:0];
//            
//            MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
//            pa.coordinate = place.coordinate;
//            pa.title = date.title;
//            
//            [mapView addAnnotation:pa];	
//            
//			// Zoom into the location		
//            MKCoordinateRegion zoom = MKCoordinateRegionMake(place.coordinate, MKCoordinateSpanMake(place.coordinateSpan.latitudeDelta * .9, place.coordinateSpan.longitudeDelta * .9));
//            
//			[mapView setRegion:zoom animated:NO];
//		}
//	}
//}

@end

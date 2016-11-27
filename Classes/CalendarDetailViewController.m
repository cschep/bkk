//
//  CalendarDetailViewController.m
//  Baby Ketten
//
//  Created by Christopher Schepman on 3/27/11.
//  Copyright Chris Schepman 2011. All rights reserved.
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = date.title;
    descText.text = date.description;
    
    NSString *city = [[NSUserDefaults standardUserDefaults] stringForKey:@"city"];
    if ([city isEqualToString:@"1"]) {
        //seattle

        //NSString *searchTerm = [self.date.where stringByReplacingOccurrencesOfString:@"pdx" withString:@"Portland, OR"];
        NSString *searchTerm = [NSString stringWithFormat:@"%@, Seattle, WA", self.date.where];
        //searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@"the woods 6637 milwauke ave" withString:@"6637 SE Milwaukie Avenue"];
        
        [self performForwardGeocode:searchTerm];
    } else {
        //portland

        // Forward geocode! - "pdx" makes the airport come up.. hrm..
        NSString *searchTerm = [self.date.where stringByReplacingOccurrencesOfString:@"pdx" withString:@"Portland, OR"];
        //searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@"the woods 6637 milwauke ave" withString:@"6637 SE Milwaukie Avenue"];
        searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@"111 sw ash" withString:@"111 sw ash, Portland, OR"];
        //NSLog(@"searching for term: %@", searchTerm);
        
        [self performForwardGeocode:searchTerm];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - map methods

- (MKAnnotationView *)mapView:(MKMapView *)sender viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"foo"];
    aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    aView.canShowCallout = YES;
    aView.animatesDrop = YES;

    return aView;
}

- (void)mapView:(MKMapView *)sender annotationView:(MKAnnotationView *)aView calloutAccessoryControlTapped:(UIControl *)control
{
    Class itemClass = [MKMapItem class];
    if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        MKMapItem *to = [[MKMapItem alloc] initWithPlacemark:self.currentPlacemark];
        MKMapItem *from = [MKMapItem mapItemForCurrentLocation];
        [MKMapItem openMapsWithItems:@[from, to] launchOptions:@{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving}];
    } else {
        NSString* addr = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=Current Location&daddr=%f,%f",aView.annotation.coordinate.latitude,aView.annotation.coordinate.longitude];
        NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)performForwardGeocode:(NSString *)string
{
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    [self.geocoder geocodeAddressString:string completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        
        self.currentPlacemark = [[MKPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]];
        
        MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
        pa.coordinate = self.currentPlacemark.location.coordinate;
        pa.title = date.title;
        [self.mapView addAnnotation:pa];
        
        // Zoom into the location
        // hacky.. 1000 looks good?
        MKCoordinateRegion zoom = MKCoordinateRegionMakeWithDistance(self.currentPlacemark.region.center, 1000, 1000);
        [self.mapView setRegion:zoom animated:NO];
    }];
}

@end

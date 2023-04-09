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

- (id)initWithDate:(Date *)date {
	if (self = [super init]) {
		self.date = date;
        self.mapView = [[MKMapView alloc] init];
        self.descriptionTextView = [[UITextView alloc] init];
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_detail_bg"]];
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
    
    self.title = self.date.title;
    self.descriptionTextView.text = self.date.description;
    
    NSString *city = [[NSUserDefaults standardUserDefaults] stringForKey:@"city"];
    if ([city isEqualToString:@"1"]) {
        //seattle
        NSString *searchTerm = [NSString stringWithFormat:@"%@, Seattle, WA", self.date.where];
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

    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.backgroundImageView];

    self.mapView.delegate = self;
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapView.layer.cornerRadius = 10;
    int mapViewBuffer = 45; //TODO: what are we doing here
    [self.view addSubview:self.mapView];

    self.descriptionTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.descriptionTextView.layer.cornerRadius = 10;
    self.descriptionTextView.font = [UIFont systemFontOfSize:22];
    self.descriptionTextView.backgroundColor = UIColor.secondarySystemBackgroundColor;
    [self.view addSubview:self.descriptionTextView];

    NSArray *constraints = @[
        [self.backgroundImageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.backgroundImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.backgroundImageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.backgroundImageView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],


        [self.mapView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:mapViewBuffer],
        [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:mapViewBuffer],
        [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-mapViewBuffer],
        [self.mapView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:.60],

        [self.descriptionTextView.topAnchor constraintEqualToAnchor:self.mapView.bottomAnchor constant:10],
        [self.descriptionTextView.leadingAnchor constraintEqualToAnchor:self.mapView.leadingAnchor],
        [self.descriptionTextView.trailingAnchor constraintEqualToAnchor:self.mapView.trailingAnchor],
        [self.descriptionTextView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-mapViewBuffer],
    ];

    [NSLayoutConstraint activateConstraints:constraints];
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
        NSURLComponents *components = [[NSURLComponents alloc] init];
        components.scheme = @"http";
        components.host = @"maps.google.com";
        components.path = @"/maps";

        NSString *daddrString = [NSString stringWithFormat:@"%f,%f",
                         aView.annotation.coordinate.latitude,
                         aView.annotation.coordinate.longitude];
        NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:@"saddr" value:@"Current Location"];
        NSURLQueryItem *queryItem2 = [[NSURLQueryItem alloc] initWithName:@"daddr" value:daddrString];
        components.queryItems = @[queryItem, queryItem2];

        [[UIApplication sharedApplication] openURL:[components URL] options:@{} completionHandler:nil];
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
        pa.title = self.date.title;

        [self.mapView showAnnotations:@[pa] animated:NO];
        self.mapView.camera.altitude *= 2;
    }];
}

@end

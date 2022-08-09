//
//  CalendarDetailViewController.h
//  Baby Ketten
//
//  Created by Christopher Schepman on 3/27/11.
//  Copyright Chris Schepman 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Date.h"

@interface CalendarDetailViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) MKPlacemark *currentPlacemark;
@property (strong, nonatomic) Date *date;
@property (strong, nonatomic) IBOutlet UITextView *descText;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (id)initWithDate:(Date *)date;

@end

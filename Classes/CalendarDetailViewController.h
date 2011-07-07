//
//  CalendarDetailViewController.h
//  Baby Ketten
//
//  Created by Christopher Schepman on 3/27/11.
//  Copyright 2011 Schepsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Date.h"
#import "BSForwardGeocoder.h"

@interface CalendarDetailViewController : UIViewController <MKMapViewDelegate, BSForwardGeocoderDelegate> {
    IBOutlet MKMapView *mapView;
    Date *date; 
    BSForwardGeocoder *forwardGeocoder;    
    
    IBOutlet UITextView *descText;
}

@property (retain, nonatomic) Date *date;
@property (retain, nonatomic) BSForwardGeocoder *forwardGeocoder;
@property (retain, nonatomic) IBOutlet UITextView *descText;

- (id)initWithDate:(Date *)date;

@end

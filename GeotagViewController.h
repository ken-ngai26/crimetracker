//
//  GeotagViewController.h
//  VPD CrimeTracker
//
//  Created by Paul Matich on 2013-03-14.
//  Copyright (c) 2013 Resursive Industries. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@protocol ModalViewDelegate;

@interface GeotagViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate> {
}

@property (nonatomic,strong) IBOutlet MKMapView *mapView;
@property (nonatomic, assign) id<ModalViewDelegate> delegate;
@property (nonatomic,strong) MKPointAnnotation *annotation;

- (IBAction)locationIsPressed:(id)sender;
- (IBAction)cancelIsPressed;

@end






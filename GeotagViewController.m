//
//  GeotagViewController.h
//  VPD CrimeTracker
//
//  Created by Paul Matich on 2013-03-14.
//  Copyright (c) 2013 Resursive Industries. All rights reserved.
//

#import "GeotagViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DisorderlyReportingViewController.h"

@interface GeotagViewController ()

@end

@implementation GeotagViewController

@synthesize mapView, annotation, delegate;

- (IBAction)locationIsPressed:(id)sender
{
    NSLog(@"The content of arry is%@",mapView.annotations);
    MKPointAnnotation *pinLocation = [mapView.annotations objectAtIndex: 0];
    CLLocation *tagLocation = [[CLLocation alloc] initWithCoordinate:pinLocation.coordinate
                                                            altitude:0
                                                  horizontalAccuracy:0
                                                    verticalAccuracy:0
                                                           timestamp:[NSDate date]];
    NSLog(@"passed latitude is: %f", annotation.coordinate.latitude );
    NSLog(@"passed longitude is: %f", annotation.coordinate.longitude );
    
    [delegate updateGeoTag:tagLocation];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelIsPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setParentController:(UIViewController*)parent{
    [self setValue:parent forKey:@"_parentViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GeoTagger" message:@"Drag pin to report location." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillAppear:(BOOL)animated
{
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    //pin.coordinate = [delegate passLocation];
    [mapView setRegion:MKCoordinateRegionMake(pin.coordinate, MKCoordinateSpanMake(0.005, 0.005)) animated:YES];
    [mapView addAnnotation:pin];
}

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)anno
{
    MKAnnotationView *annotationView = [mv dequeueReusableAnnotationViewWithIdentifier:@"PinAnnotationView"];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:anno reuseIdentifier:@"PinAnnotationView"];
        annotationView.draggable = YES;
    }
    
    return annotationView;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


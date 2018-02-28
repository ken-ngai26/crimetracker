//
// CrimeMapViewController.m
// VPD CrimeTracker
//
// Created by Michael Nguyen on 2013-02-04.
// Copyright (c) 2013 Resursive Industries. All rights reserved.
//
#import "CrimeMapViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "MyPlace.h"
#import <MapKit/MapKit.h>
#import "Reachability.h"

@interface CrimeMapViewController ()
@end
@implementation CrimeMapViewController {
    NSString *url;
    NSData *data;
    NSError* error;
    
    NSArray* json;
    
}


@synthesize mapView;
-(IBAction)graffitiPressed:(id)sender{
    [self reDrawPins];
}
-(IBAction)brokenLightsPressed:(id)sender{
    [self reDrawPins];
}
-(IBAction)potholesPressed:(id)sender{
    [self reDrawPins];
    
}
-(IBAction)dumpingPressed:(id)sender{
    [self reDrawPins];
}
-(IBAction)stolenVehiclePressed:(id)sender{
    [self reDrawPins];
}
-(IBAction)otherPressed:(id)sender{
    [self reDrawPins];
}
-(IBAction)allPressed:(id)sender{
    graffiti.on = YES;
    brokenLights.on = YES;
    potholes.on = YES;
    dumping.on = YES;
    stolenVehicle.on = YES;
    other.on = YES;
    [self reDrawPins];
}
-(IBAction)nonePressed:(id)sender{
    graffiti.on = NO;
    brokenLights.on = NO;
    potholes.on = NO;
    dumping.on = NO;
    stolenVehicle.on = NO;
    other.on = NO;
    [self reDrawPins];
}
#define vancouver CLLocationCoordinate2DMake(49.251597, -123.102951)
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // sets background image to fit to view
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"final-bg.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // sets view layer settings
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    // Check for connection
    if ([self connected] == YES) {
        [mapView setDelegate:self];
        mapView.delegate = self;
        
        [mapView setRegion:MKCoordinateRegionMake(vancouver, MKCoordinateSpanMake(0.20, 0.20)) animated:YES];
        
        url = @"http://soulshunters.host-ed.me/getAllEmailReport.php";
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        json = [NSJSONSerialization
                JSONObjectWithData:data
                options:kNilOptions
                error:nil];
        [self reDrawPins];
        
    }
    else {
        NSLog(@"Error, no internet!!");
        UIAlertView* noInternet = [[UIAlertView alloc]initWithTitle:@"No Connection Error"
                                                            message:@"No Internet Connection Found. Please try again when you have internet."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [noInternet show];
    }
    

    
    
}

//*****************************************
- (BOOL)connected // Checks for internet connection
{
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.ca"];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}


// Reveal the menu
- (IBAction)revealMenu:(id)sender
{
    // Move view to right
    [self.slidingViewController anchorTopViewTo:ECRight];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)reDrawPins {

    [mapView removeAnnotations:mapView.annotations];
    NSLog(@"REdrawing pins");
    CLLocationCoordinate2D coord;
    NSDictionary *reportDic;
    NSString *lat;
    NSString *lng;
    NSString *type;
    NSString *description;
    for (int i=0; i<json.count; i++) {
        MyPlace *aReport;
        reportDic = [json objectAtIndex:i];
        lat = [reportDic objectForKey:@"lat"];
        lng = [reportDic objectForKey:@"lng"];
        type = [reportDic objectForKey:@"reportType"];
        description = [reportDic objectForKey:@"description"];
        coord.latitude = [lat doubleValue];
        coord.longitude = [lng doubleValue];
        
        if (([type integerValue] == 1) & graffiti.on) {
            NSLog(@"redrawing all graffiti pins");
            aReport = [[MyPlace alloc] initWithCoordinate:coord];
            [aReport setCurrentTitle:@"Graffiti"];
            [aReport setCurrentSubTitle:description];
            [mapView addAnnotation:aReport];
        }
        if (([type integerValue] == 2) & brokenLights.on) {
            NSLog(@"redrawing all broken lights pins");

            aReport = [[MyPlace alloc] initWithCoordinate:coord];
            [aReport setCurrentTitle:@"Broken Street Light"];
            [aReport setCurrentSubTitle:description];
            [mapView addAnnotation:aReport];
        }
        if (([type integerValue] == 3) & dumping.on) {
            NSLog(@"redrawing all dumping pins");

            aReport = [[MyPlace alloc] initWithCoordinate:coord];
            [aReport setCurrentTitle:@"Dumping"];
            [aReport setCurrentSubTitle:description];
            [mapView addAnnotation:aReport];
        }
        if (([type integerValue] == 4) & potholes.on) {
            NSLog(@"redrawing all potholes pins");

            aReport = [[MyPlace alloc] initWithCoordinate:coord];
            [aReport setCurrentTitle:@"Pothole"];
            //NSLog([potholesPlaces title]);
            [aReport setCurrentSubTitle:description];
            [mapView addAnnotation:aReport];
        }
        if (([type integerValue] == 5) & stolenVehicle.on) {
            NSLog(@"redrawing all stolen vehicle pins");

            aReport = [[MyPlace alloc] initWithCoordinate:coord];
            [aReport setCurrentTitle:@"Possible Stolen Vehicle"];
            [aReport setCurrentSubTitle:description];
            [mapView addAnnotation:aReport];
        }
        if (([type integerValue] == 6) & other.on) {
            NSLog(@"redrawing all other pins");

            aReport = [[MyPlace alloc] initWithCoordinate:coord];
            [aReport setCurrentTitle:@"Other"];
            [aReport setCurrentSubTitle:description];
            [mapView addAnnotation:aReport];
        }
        
    }
}
-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKPinAnnotationView *MyPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myPin"];
    
    if ([[annotation title] isEqualToString:@"Graffiti"]) {
            MyPin.image = [UIImage imageNamed:@"pinRed.png"];
    }
    if ([[annotation title] isEqualToString:@"Broken Street Light"]) {
        //NSLog(@"inside bsl");
            MyPin.image = [UIImage imageNamed:@"pinOrange.png"];
    }
    if ([[annotation title] isEqualToString:@"Pothole"]) {
            MyPin.image = [UIImage imageNamed:@"pinYellow.png"];
    }
    if ([[annotation title] isEqualToString:@"Dumping"]) {
            MyPin.image = [UIImage imageNamed:@"pinPurple.png"];
    }
    if ([[annotation title] isEqualToString:@"Possible Stolen Vehicle"]) {
            MyPin.image = [UIImage imageNamed:@"PinGreen.png"];
    }
    if ([[annotation title] isEqualToString:@"Other"]) {
            MyPin.image = [UIImage imageNamed:@"pinGray.png"];
    }
    MyPin.canShowCallout = YES;
    return MyPin;
}



@end
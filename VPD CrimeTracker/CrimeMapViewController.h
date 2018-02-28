//
//  CrimeMapViewController.h
//  VPD CrimeTracker
//
//  Created by Michael Nguyen on 2013-02-04.
//  Copyright (c) 2013 Resursive Industries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CrimeMapViewController : UIViewController <MKMapViewDelegate>{
    IBOutlet MKMapView *mapView;
    
    __strong IBOutlet UISwitch *graffiti;
    __strong IBOutlet UISwitch *brokenLights;
    __strong IBOutlet UISwitch *potholes;
    __strong IBOutlet UISwitch *dumping;
    __strong IBOutlet UISwitch *stolenVehicle;
    __strong IBOutlet UISwitch *other;
    __strong IBOutlet UIButton *all;
    __strong IBOutlet UIButton *none;
    
}
@property (strong, nonatomic) UIButton *menuBtn;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;


-(IBAction)graffitiPressed:(id)sender;
-(IBAction)brokenLightsPressed:(id)sender;
-(IBAction)potholesPressed:(id)sender;
-(IBAction)dumpingPressed:(id)sender;
-(IBAction)stolenVehiclePressed:(id)sender;
-(IBAction)otherPressed:(id)sender;
-(IBAction)allPressed:(id)sender;
-(IBAction)nonePressed:(id)sender;
-(void)reDrawPins;

@end
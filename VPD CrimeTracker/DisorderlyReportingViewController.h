//
//  DisorderlyReportingViewController.h
//  VPD CrimeTracker
//
//  Created by Michael Nguyen on 2013-01-31.
//  Copyright (c) 2013 Resursive Industries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import "UIDropDownMenu.h"
#import "GeotagViewController.h"

@protocol ModalViewDelegate

- (IBAction)updateGeoTag:(CLLocation *)newLocation;

@end

@interface DisorderlyReportingViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UIDropDownMenuDelegate, MFMailComposeViewControllerDelegate, ModalViewDelegate> {
    
    NSFileManager *fileManager;
    IBOutlet UISegmentedControl *sc;
    IBOutlet UIImageView     *imageView;
    UIImagePickerController *picker2;
    
    // Drop down menu
    UIDropDownMenu *reportDisplayMenu;
}

// Text Field Outlets
@property (nonatomic, retain) GeotagViewController *coorData;
@property (strong, nonatomic) IBOutlet UITextField *reportDisplay;
@property (strong, nonatomic) IBOutlet UITextField *locationDisplay;
@property (strong, nonatomic) IBOutlet UITextView *descriptionDisplay;
@property (strong, nonatomic) NSArray* informationHistoryArray;

// Drop down menu
@property(strong, nonatomic) UIDropDownMenu *reportDisplayMenu;


// Button press Actions
- (IBAction)doneIsPressed:(id)sender;
- (IBAction)saveIsPressed:(id)sender;
- (IBAction)newIsPressed:(id)sender;
- (IBAction)emailIsPressed:(id)sender;
- (IBAction)gpsIsPressed:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)geotagIsPressed:(id)sender;

// Camera Actions
- (IBAction)getCurrentLocation:(id)sender;
- (IBAction)camera;

// Database Actions
- (void) pushToDatabaseWithEmail:(NSString *)email reportType:(NSString *)reportType description:(NSString *)description lat:(NSString *)lat lng:(NSString *)lng photoUrl:(NSString *)photoUrl date:(NSString *)date address:(NSString *)address;

@end

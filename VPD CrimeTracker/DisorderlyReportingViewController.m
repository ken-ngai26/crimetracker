//
//  DisorderlyReportingViewController.m
//  VPD CrimeTracker
//
//  Created by Michael Nguyen on 2013-01-31.
//  Copyright (c) 2013 Resursive Industries. All rights reserved.
//
//Test

#import "DisorderlyReportingViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "HistoryViewController.h"

@interface DisorderlyReportingViewController ()

@property(nonatomic) NSArray* userInformation;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic,strong) CLGeocoder *geocoder;
@property(nonatomic, strong) CLPlacemark *placemark;

@end

@implementation DisorderlyReportingViewController {
    int BLOCKINGFACTOR;
    
    // Obtaining the file location
    NSArray *paths;
    NSString *docDir;
    
    // Recieving user information.
    NSData *userInformationFromFile;
    NSArray *userInformation;

    NSString *currentUserLogin;
    
    // File path takes on the form of [email]VPDUserInformation.txt where [email] is the current email that is logged in
    NSString *filePath;
    
    
    double latitude;
    double longitude;
    
}

@synthesize userInformation = _userInformation;
@synthesize locationManager = _locationManager;
@synthesize reportDisplayMenu = _reportDisplayMenu;



// View Controller start - first function to run
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Set the blocking Factor
    BLOCKINGFACTOR = 6;
    
    //Set the DropDownMenu initation
    [self menuSetup];
    
    // sets background image to fit to view
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"final-bg.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    // Attributes for slide menu
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];

    // Initialize File Manager and Set Data
    fileManager = [NSFileManager defaultManager];
    
    
    // Default No selected for switch control
    sc.selectedSegmentIndex = -1;
    
    // User Location
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Geocoder
    self.geocoder = [[CLGeocoder alloc] init];
    
    // FROM HISTORY
    NSLog(@"************information history array:  %@", self.informationHistoryArray);
    
    // View was instantiated from the history, therefore going to preset the values given by historyviewcontroller
    if ([[self.informationHistoryArray objectAtIndex:0] intValue] == 1){

        // Obtaining the file location
        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docDir = [paths objectAtIndex:0];
        
        // Recieving user information.
        userInformationFromFile = [[NSData alloc] initWithContentsOfFile:[docDir stringByAppendingString:@"/UserInformation.txt"]];
        userInformation = [NSKeyedUnarchiver unarchiveObjectWithData:userInformationFromFile];
        NSLog(@"User Information: %@", userInformation);
        currentUserLogin = [userInformation objectAtIndex:0];
        NSLog(@"CurrentUserLogin: %@", currentUserLogin);
        
        // File path takes on the form of [email]VPDUserInformation.txt where [email] is the current email that is logged in
        filePath = [docDir stringByAppendingFormat:@"/%@VPDUserInformation.txt", currentUserLogin];
        
        NSLog(@"File Path: %@",filePath);
        
        // Get the current information from the file
        NSData *dataFromFile = [[NSData alloc] initWithContentsOfFile:filePath];
        NSArray *arrayFromFile = [NSKeyedUnarchiver unarchiveObjectWithData:dataFromFile];
        
        int indexReportArray = [[self.informationHistoryArray objectAtIndex:1] intValue];
        NSArray *historyReportArray = [HistoryViewController reportArray:arrayFromFile atIndex:indexReportArray blockingFactor:BLOCKINGFACTOR];
        
        //Set all of the fields from the history
        self.reportDisplay.text = [historyReportArray objectAtIndex:1];
        self.locationDisplay.text = [historyReportArray objectAtIndex:2];
        self.descriptionDisplay.text = [historyReportArray objectAtIndex:3];
        
        NSData *imageData = [historyReportArray objectAtIndex:5];
        UIImage *historyImage = [UIImage imageWithData:imageData];
        imageView.image = historyImage;
    }
    
}

// Dismisses the keyboard
- (IBAction)dismissKeyboard:(id)sender {
    [self.locationDisplay resignFirstResponder];
    [self.descriptionDisplay  resignFirstResponder];
}

// Closes the keyboard when the user presses done. UITextField delegate method
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// UITextView Delegate method
// closes the keyboard when done is pressed.
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){ // hacky... scans for a newline key
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
    
}


// UIAlertView Delegate method - checks what to do with specific alerts that are called
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // newIsPressed UIAlertView Delegate Method
    if (alertView.tag == 200){
        if (buttonIndex==0){
            NSLog(@"DO NOTHING");
            
        }
        else if (buttonIndex==1){
            NSLog(@"CREATE NEW");
            
            // Return all the fields to their defaults
            self.reportDisplay.text = @"";
            self.locationDisplay.text = @"";
            self.descriptionDisplay.text = @"";
            [imageView setImage:[UIImage imageNamed:@"camera.jpg"]];
            sc.selectedSegmentIndex = -1;
        }
        
    }
    
    // saveIsPressed UIAlertView Delegate method
    if (alertView.tag == 100) {
        NSLog(@"SAVE IS PRESSED");
        if (buttonIndex==1) {
            
            // Obtaining the file location
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            docDir = [paths objectAtIndex:0];
            
            // Recieving user information.
            userInformationFromFile = [[NSData alloc] initWithContentsOfFile:[docDir stringByAppendingString:@"/UserInformation.txt"]];
            userInformation = [NSKeyedUnarchiver unarchiveObjectWithData:userInformationFromFile];
            NSLog(@"User Information: %@", userInformation);
            currentUserLogin = [userInformation objectAtIndex:0];
            NSLog(@"CurrentUserLogin: %@", currentUserLogin);
            
            // File path takes on the form of [email]VPDUserInformation.txt where [email] is the current email that is logged in
            filePath = [docDir stringByAppendingFormat:@"/%@VPDUserInformation.txt", currentUserLogin];
            NSLog(@"File Path: %@",filePath);
            
            
            // Get the current date with system time zone
            // Gets the current date and formats it to local time zone
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSString *stringDate = [dateFormatter stringFromDate:currentDate];
            
            NSString *titleName = [[alertView textFieldAtIndex:0] text];
            
            // File already exists
            if ([fileManager fileExistsAtPath:filePath]){
                // Load the file because it exits
                
                // Get the current information from the file
                NSData *dataFromFile = [[NSData alloc] initWithContentsOfFile:filePath];
                NSArray *arrayFromFile = [NSKeyedUnarchiver unarchiveObjectWithData:dataFromFile];
                //NSLog(@"Array from memory: %@", arrayFromFile);
                
                // Append the new information to the array
                NSArray *updatedArray = [arrayFromFile arrayByAddingObject:titleName];          // 0. Title of the Report - defaults to time
                updatedArray = [updatedArray arrayByAddingObject:self.reportDisplay.text];      // 1. Report type
                updatedArray = [updatedArray arrayByAddingObject:self.locationDisplay.text];    // 2. Location
                updatedArray = [updatedArray arrayByAddingObject:self.descriptionDisplay.text]; // 3. Description of report
                updatedArray = [updatedArray arrayByAddingObject:stringDate];                   // 4. Time stamp of report
                updatedArray = [updatedArray arrayByAddingObject:UIImageJPEGRepresentation(imageView.image, 0.0001)]; // 5. Image of report
                
                
                //NSLog(@"Updated Array: %@", updatedArray);
                
                // Save the array back to the file
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:updatedArray];
                [data writeToFile:filePath atomically:YES];
                
                //NSLog(@"Updated information in: %@", filePath);
            }
            else {
                // The file does not exit - Create it and save information to it
                NSArray *updatedArray = [NSArray arrayWithObjects:titleName, self.reportDisplay.text, self.locationDisplay.text, self.descriptionDisplay.text, stringDate, UIImageJPEGRepresentation(imageView.image, 0.0001), nil];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:updatedArray];
                [data writeToFile:filePath atomically:YES];
                NSLog(@"File does not exit yet - Creating it");
                //NSLog(@"Updated Information %@", updatedArray);
            }
            
            // In case of empty fields...
            NSString *reportNum = @"0";
            if (![self.reportDisplay.text isEqualToString:@""]) {
                reportNum = [self.reportDisplay.text substringToIndex:1];
            }
            
            // PUSHING THE DATA ONTO THE DATABASE
            [self pushToDatabaseWithEmail:currentUserLogin reportType:reportNum description:self.descriptionDisplay.text lat:[NSString stringWithFormat:@"%f",latitude] lng:[NSString stringWithFormat:@"%f",longitude]  photoUrl:@"" date:stringDate address:self.locationDisplay.text];
        }
        
    }
}

// Custom initalization for userInformation NSArray
- (NSArray*) userInformation{
    
    // Lazy instantiation
    if (_userInformation == Nil){
        _userInformation = [[NSArray alloc] init];
    }
    return _userInformation;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


// ReportDisplayMenu Setup
- (void)menuSetup {
    // Allocate dropdown menu with an identifier string
    reportDisplayMenu = [[UIDropDownMenu alloc] initWithIdentifier:@"reportDisplayMenu"];
    
    // NSMutable array to hold menu list items
    NSMutableArray *reportTypes = [[NSMutableArray alloc] initWithObjects:@"1 - Graffiti", @"2 - Broken Streetlights", @"3 - Illegal Dumping", @"4 - Potholes", @"5 - Possible Stolen Vehicle", @"6 - Other", nil];
    
    // Settings
    reportDisplayMenu.ScaleToFitParent = TRUE;
    reportDisplayMenu.titleArray = reportTypes;
    reportDisplayMenu.valueArray = reportTypes;
    [reportDisplayMenu makeMenu:self.reportDisplay targetView:self.view];
    reportDisplayMenu.delegate = self;
}

// Triggered when a Drop Down Menu Item is selected
- (void) DropDownMenuDidChange:(NSString *)identifier :(NSString *)ReturnValue  {
    // Identifier is the report display menu
    if ([identifier isEqualToString:@"reportDisplayMenu"]){
        self.reportDisplay.text = ReturnValue;
        
    }
        
}

// UIDropDownMenu Delegate method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


// Reveal the menu
- (IBAction)revealMenu:(id)sender {
    
    // Dismiss keyboard
    [self dismissKeyboard:nil];
    
    // Move view to right
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Title alert
- (UIAlertView*) askForTitleName {
    // Displays the alert to get the users title before saving into memory
    UIAlertView *titleNameAlert = [[UIAlertView alloc] initWithTitle:@"Would you like to title this report?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [titleNameAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    // The the alert
    [titleNameAlert show];
    
    return titleNameAlert;
    
}

// Test Button is pressed - used for debugging
- (IBAction)doneIsPressed:(id)sender {
    
    // Closes the keyboard
    [self.reportDisplay resignFirstResponder];
    [self.locationDisplay resignFirstResponder];
    [self.descriptionDisplay resignFirstResponder];
    
    // Test - showing the image
    NSLog(@"The image: %@", imageView.image);

    // send to website to register onto the database
    NSString *url =[NSString stringWithFormat:@"http://soulshunters.host-ed.me/register.php?Email=%@&password=%@&firstName=%@&lastName=%@&userType=%@&adminID=%d&phoneNumber=%d",@"mhnguyen@sfu.ca",@"12345",@"Michael",@"Nguyen",@"1232",1 ,1];
    NSLog(@"%@",url);
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [req setHTTPMethod:@"GET"]; // This might be redundant, I'm pretty sure GET is the default value
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [connection start];
}

// Save button is pressed - saves information into VPDUserInformation.txt locally onto the users iPhone
- (IBAction)saveIsPressed:(id)sender {
    
    // Gets the current date and formats it to local time zone
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *stringDate = [dateFormatter stringFromDate:currentDate];


    // Displays the alert to get the users title before saving into memory
    UIAlertView *titleNameAlert = [[UIAlertView alloc] initWithTitle:@"Please name your report" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    titleNameAlert.tag = 100;
    
    // Sets the alert to take text input
    [titleNameAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    UITextField *textField = [titleNameAlert textFieldAtIndex:0];
    textField.text = stringDate;
    
    // Shows the alert
    [titleNameAlert show];
}

// New Button is Pressed - clears the form
- (IBAction)newIsPressed:(id)sender {
    UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"New Report" message:@"All current information will be deleted. Are you sure you want to do this?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    newAlert.tag = 200;
    [newAlert show];
    
}

// Email button is pressed
- (IBAction)emailIsPressed:(id)sender {
    /*
    UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Email Report" message:@"This feature is still under construction." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    newAlert.tag = 300;
    [newAlert show];
    */
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    NSArray *emailAddresses = [[NSArray alloc] initWithObjects:@"mhnguyen@sfu.ca", nil];
    
    //Get strings for subject and message
    NSString *emailSubject = @"VPD CrimeTracker";
    NSString *emailMessage = [NSString stringWithFormat:@"<html> <b>Report Type:</b> %@ <br> <b>Location:</b> %@ <br> <b>Description:</b> %@ <br> <b>Image:</b> %@ <br> </html>", self.reportDisplay.text, self.locationDisplay.text, self.descriptionDisplay.text, @""];
    
    // Set email addresses in the mail viewer
    [mailComposer setToRecipients:emailAddresses];
    [mailComposer setSubject:emailSubject];
    [mailComposer setMessageBody:emailMessage isHTML:YES];
    
    [self presentViewController:mailComposer animated:YES completion:nil];
     
}

// Email delegate methods
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil]; // Close the email view - returns back to disorderly report.
}

// GPS button is pressed
- (IBAction)gpsIsPressed:(id)sender {
    [self getCurrentLocation:NULL];
}
- (IBAction)geotagIsPressed:(id)sender{
    /*
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
    [self dismissModalViewControllerAnimated:YES];
     */
}


- (IBAction)updateGeoTag:(CLLocation *)newLocation {
    NSLog(@"passed latitude is: %f", newLocation.coordinate.latitude );
    NSLog(@"passed longitude is: %f", newLocation.coordinate.longitude );
    NSLog(@"Resolving the Address");
    [self.geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
            NSString *addressString = [NSString stringWithFormat:@"%@ %@ %@, %@",
                                       self.placemark.subThoroughfare, self.placemark.thoroughfare,
                                       self.placemark.locality,
                                       self.placemark.administrativeArea];
            NSLog(@"Address text: %@", addressString);
            self.locationDisplay.text = addressString;
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}



// Get Current Location
- (IBAction)getCurrentLocation:(id)sender {
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
}



#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

// Get Location from GPS
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSLog(@"Longitude: %@", [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
        NSLog(@"Latitude: %@", [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
        
        
        longitude = currentLocation.coordinate.longitude;
        latitude = currentLocation.coordinate.latitude;

        //longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        //latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    // Stops the location manager.
    [self.locationManager stopUpdatingLocation];
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
            NSString *addressString = [NSString stringWithFormat:@"%@ %@ %@, %@",
                                 self.placemark.subThoroughfare, self.placemark.thoroughfare,
                                 self.placemark.locality,
                                 self.placemark.administrativeArea];
            NSLog(@"Address text: %@", addressString);
            self.locationDisplay.text = addressString;
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

// Camera Action
- (IBAction)camera {
    picker2 = [[UIImagePickerController alloc] init];
    picker2.delegate = self;
    
    if (sc.selectedSegmentIndex == 0) {
        [picker2 setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else if (sc.selectedSegmentIndex == 1) {
        [picker2 setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [self presentViewController:picker2 animated:YES completion:Nil];
}

// Set the image to the imagedisplay
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:image];
    
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

// Push all the current fields to the database.
- (void) pushToDatabaseWithEmail:(NSString *) email reportType:(NSString *)reportType description:(NSString *)description lat:(NSString *)lat lng:(NSString *)lng photoUrl:(NSString *)photoUrl date:(NSString *)date address:(NSString *)address {
    
    NSLog(@"Pushing to database");
    NSLog(@"Email: %@, reportType: %@, description: %@, lat: %@, lng: %@, photoURL: %@, date: %@, address: %@", email, reportType, description, lat, lng, photoUrl, date, address);
    
    // Pushes information onto the database
    NSString *url =[NSString stringWithFormat:@"http://soulshunters.host-ed.me/sendReport.php?Email=%@&reportType=%@&description=%@&photoURL=%@&lat=%@&lng=%@&date=%@&address=%@",email,reportType,description,photoUrl,lat,lng,date,address];
    
    // Replacing all empty spaces with %20, which is the html equivalent
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"%@",url);
    
     NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
     [req setHTTPMethod:@"GET"]; // This might be redundant, I'm pretty sure GET is the default value
     NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
     [connection start];

}


@end

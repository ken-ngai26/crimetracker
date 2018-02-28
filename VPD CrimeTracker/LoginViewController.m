//
//  LoginViewController.m
//  VPD CrimeTracker
//
//  Created by Michael Nguyen on 2013-03-02.
//  Copyright (c) 2013 Resursive Industries. All rights reserved.
//

#import "LoginViewController.h"
#import "InitViewController.h"
#import "Reachability.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    // Obtaining the file location
    NSArray *paths;
    NSString *docDir;
    NSString *filePath;
    NSFileManager *fileManager;
}


// Synthesize the instance variables of our properties.
@synthesize usernameTextBox= _usernameTextBox;
@synthesize passwordTextBox = _passwordTextBox;

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
	// Do any additional setup after loading the view.

    // Hide the activity indicator on loadup
    self.activityIndicator.hidden = YES;

    // Initialize File Manager and Set Data
    fileManager = [NSFileManager defaultManager];
    
    // sets background image to fit to view
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"final-bg.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    // Set tag id for text boxes
    self.usernameTextBox.tag = 100;
    self.passwordTextBox.tag = 200;
    
    
    // Obtaining the file location
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docDir = [paths objectAtIndex:0];
    NSLog(@"DOCDIR: %@",docDir);
    
    // If UserInformation.txt file exists
    if ([fileManager fileExistsAtPath:[docDir stringByAppendingPathComponent:@"UserInformation.txt"]]) {
        // Recieving user information.
        NSData *userInformationFromFile = [[NSData alloc] initWithContentsOfFile:[docDir stringByAppendingString:@"/UserInformation.txt"]];
        NSArray *userInformation = [NSKeyedUnarchiver unarchiveObjectWithData:userInformationFromFile];
        
        NSString *switchBoolValue = [userInformation objectAtIndex:2];
        // Stored saved bool value from userInformation.txt file
        if ([switchBoolValue isEqualToString:@"YES"]) {
            self.rememberMeSwitch.on = YES;
        }
        else {
            self.rememberMeSwitch.on = NO;
        }
    }
    
    // Tap Recognizer to close keyboard When view is tapped with keyboard open
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap]; // Add tap to the view
        
    
    // Remember Me Switch
    if (self.rememberMeSwitch.on == YES) {
        NSLog(@"Remember Me is ON");
        
        // If UserInformation.txt file exists
        if ([fileManager fileExistsAtPath:[docDir stringByAppendingPathComponent:@"UserInformation.txt"]]) {
            // Recieving user information.
            NSData *userInformationFromFile = [[NSData alloc] initWithContentsOfFile:[docDir stringByAppendingString:@"/UserInformation.txt"]];
            NSArray *userInformation = [NSKeyedUnarchiver unarchiveObjectWithData:userInformationFromFile];
            NSLog(@"User Information: %@", userInformation);
            NSString *currentUserLogin = [userInformation objectAtIndex:0];
            NSLog(@"CurrentUserLogin: %@", currentUserLogin);
            NSString *currentUserPassword = [userInformation objectAtIndex:1];
            NSLog(@"remember me: %@", [userInformation objectAtIndex:2]);
            
            // Set the username and password text fields to automaticaly fill in if remember me is on
            self.usernameTextBox.text = currentUserLogin;
            self.passwordTextBox.text = currentUserPassword;
            
        }

        
    }
    else {
        NSLog(@"Remember Me is OFF");
        self.usernameTextBox.text = @"";
        self.passwordTextBox.text = @"";
        
    }
    
}

// Dismisses the keyboard
- (void) dismissKeyboard {
    [self.usernameTextBox resignFirstResponder];
    [self.passwordTextBox resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Closes the keyboard when the user presses done. UITextField delegate method
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    // move for kdb
    //NSLog(@"Before: %f", self.view.frame.origin.y);
    //NSLog(@"Textfield tag: %d", textField.tag);
    
    if (self.view.frame.origin.y == -100) {
        return;
    }
    else {
        // start animation
        /*
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.2f];
         */
        
        CGRect frame = self.view.frame;
        
        frame.origin.y = -100;
        
        // move it
        [self.view setFrame:frame];
        
        //NSLog(@"After: %f", self.view.frame.origin.y);
        
        //[UIView commitAnimations];
    }
    

}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    // move for kdb
    if (self.view.frame.origin.y == 20) {
        return;
    }
    else {
        // start animation
        /*
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.2f];
         */
        
        CGRect frame = self.view.frame;
        
        frame.origin.y = 20;
        
        // move it
        [self.view setFrame:frame];
        
        //[UIView commitAnimations];
        
    }
}

//*****************************************
- (BOOL)connected // Checks for internet connection
{
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.ca"];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

// Login button is pressed
- (IBAction)loginIsPressed:(id)sender {
    
    // Checking for internet
    if ([self connected] == YES) {
        NSLog(@"Internet Check passed... logging in");
        // Show the Load animation
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        // Login logic located in -(void) login function
        [self performSelector:@selector(login) withObject:nil afterDelay:0.001f];
    }
    else {
        NSLog(@"Error, no internet!!");
        UIAlertView* noInternet = [[UIAlertView alloc]initWithTitle:@"No Connection Error"
                                                            message:@"No Internet Connection Found. Please try again when you have internet, or use Offline Mode"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [noInternet show];
    }

}

// Login in logistics
- (void)login {
    
    // User inputted information from the Login View
    NSString *userEmail = self.usernameTextBox.text;
    NSString *userPassword = self.passwordTextBox.text;
    
    
    // accessing database to check the input email and password match with database
    // Programmed by Ken
    
    NSString *post =[NSString stringWithFormat:@"Email=%@&password=%@" ,userEmail, userPassword];
    
    NSString *hostStr = @"http://soulshunters.host-ed.me/checklogin.php?";
    hostStr = [hostStr stringByAppendingString:post];
    
    // Replacing all empty spaces with %20, which is the html equivalent
    hostStr = [hostStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSData *dataURL = [NSData dataWithContentsOfURL: [ NSURL URLWithString: hostStr ]];
    
    NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSASCIIStringEncoding];
    // if php file return yes then login is successful else something is wrong
    
    serverOutput = [serverOutput substringWithRange:NSMakeRange(1,3)];
    NSLog(@"The server output: %@", serverOutput);
    
    
    // User and password match
    if([serverOutput isEqualToString:@"YES"]){
        
        // Save current user information to a text file.
        
        NSString *boolSwitchValue;
        if (self.rememberMeSwitch.on == YES){
            boolSwitchValue = @"YES";
        }
        else {
            boolSwitchValue = @"NO";
        }
        
        NSArray *userInformation = [[NSArray alloc] initWithObjects:self.usernameTextBox.text, self.passwordTextBox.text, boolSwitchValue, nil];
        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userInformation];
        
        NSLog(@"User Information %@", userInformation);
        //Save to File
        filePath = [docDir stringByAppendingPathComponent:@"UserInformation.txt"];
        [userData writeToFile:filePath atomically:YES];
        
        
        
        InitViewController *init = [self.storyboard instantiateViewControllerWithIdentifier:@"Init"];
        // Pushes onto the screen
        [self presentViewController:init animated:YES completion:nil];
        
        
        
        
    }
    // Username and password are not in the data base.
    else {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username or Password Incorrect"
                                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
        
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
    }
    
}

// Register button is pressed
- (IBAction)registerIsPressed:(id)sender {
}

// Debugger is pressed
- (IBAction)debuggerIsPressed:(id)sender {

}

- (IBAction)useOfflineIsPressed:(id)sender {
    
    // Save current user information to a text file.
    
    NSString *boolSwitchValue;
    if (self.rememberMeSwitch.on == YES){
        boolSwitchValue = @"YES";
    }
    else {
        boolSwitchValue = @"NO";
    }
    
    NSArray *userInformation = [[NSArray alloc] initWithObjects:@"", @"", boolSwitchValue, nil];
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userInformation];
    
    NSLog(@"User Information %@", userInformation);
    //Save to File
    filePath = [docDir stringByAppendingPathComponent:@"UserInformation.txt"];
    [userData writeToFile:filePath atomically:YES];

}




@end
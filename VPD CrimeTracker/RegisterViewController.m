//
//  RegisterViewController.m
//  VPD CrimeTracker
//
//  Created by Michael Nguyen on 2013-03-05.
//  Copyright (c) 2013 Resursive Industries. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "Reachability.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    
    // sets background image to fit to view
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"final-bg.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // Tap Recognizer to close keyboard When view is tapped with keyboard open
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap]; // Add tap to the view
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Dismisses the keyboard
- (void) dismissKeyboard {
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField  resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.confirmEmailTextField  resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField  resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
}


// Closes the keyboard when the user presses done. UITextField delegate method
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// Move entire view up when keyboard is pressed
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    //NSLog(@"Before: %f", self.view.frame.origin.y);
    //NSLog(@"Textfield tag: %d", textField.tag);
    
    if (self.view.frame.origin.y == -115) {
        return;
    }
    else {
        // start animation
        //CGContextRef context = UIGraphicsGetCurrentContext();
        //[UIView beginAnimations:nil context:context];
        //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        //[UIView setAnimationDuration:0.2f];
        
        CGRect frame = self.view.frame;
        
        frame.origin.y = -115;
        
        // move it
        [self.view setFrame:frame];
        
        //NSLog(@"After: %f", self.view.frame.origin.y);
        
        //[UIView commitAnimations];
    }
}

// Move view down when keyboard is finished
- (void) textFieldDidEndEditing:(UITextField *)textField {
    if (self.view.frame.origin.y == 20) {
        return;
    }
    else {
        // start animation
        //CGContextRef context = UIGraphicsGetCurrentContext();
        //[UIView beginAnimations:nil context:context];
        //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        //[UIView setAnimationDuration:0.2f];
        
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

- (IBAction)registerIsPressed:(id)sender {
    
    if ([self connected] == YES) {
        // Storing text data into string variables for easy manipulation.
        NSString *firstName = self.firstNameTextField.text;
        NSString *lastName = self.lastNameTextField.text;
        NSString *email = self.emailTextField.text;
        NSString *confirmEmail = self.confirmEmailTextField.text;
        NSString *password = self.passwordTextField.text;
        NSString *confirmPassword = self.confirmPasswordTextField.text;
        NSString *phoneNumber = self.phoneNumberTextField.text;
        
        
        // Check if passwordTextField and confirmPasswordTextField match
        if ([password isEqualToString:confirmPassword] && ![password isEqualToString:@""] && ![confirmPassword isEqualToString:@""] && ![email isEqualToString:@""] && [email isEqualToString:confirmEmail]){
            NSLog(@"The passwords match");
            
            // Push the user information onto the database
            // the field is the register fields
            NSString *url =[NSString stringWithFormat:@"http://soulshunters.host-ed.me/register.php?Email=%@&password=%@&firstName=%@&lastName=%@&phoneNumber=%@",email, password, firstName, lastName, phoneNumber];
            
            // Replacing all empty spaces with %20, which is the html equivalent
            url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            NSLog(@"%@",url);
            
            NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            [req setHTTPMethod:@"GET"]; // This might be redundant, I'm pretty sure GET is the default value
            NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
            
            // Start
            [connection start];
            
            UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Registration was successful."
                                                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alertsuccess show];
            
            
            // Switch back to the login screen for user to login with newly created account
            
            // if successfull instantiate the init class, which will then instantiate the home view
            LoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            // Pushes onto the screen
            [self presentViewController:loginView animated:YES completion:nil];
            
        }
        else if (![password isEqualToString:confirmPassword]){
            NSLog(@"The passwords do not match");
            
            UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Registration Error" message:@"Please make sure your passwords match"
                                                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertsuccess show];
        }
        // Emails do not match.
        else if (![email isEqualToString:confirmEmail]){
            // Email does not match
            NSLog(@"The emails do not match");
            
            UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Registration Error" message:@"Please make sure your emails match"
                                                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertsuccess show];
        }
        // User has not entered all of the fields.
        else if ([email isEqualToString:@""] || [password isEqualToString:@""] || [confirmPassword isEqualToString:@""]){
            NSLog(@"Missing entries");
            
            UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Registration Error" message:@"Please fill in all of the required fields"
                                                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertsuccess show];
        }
        
    }
    // No internet!! Try again later
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
@end

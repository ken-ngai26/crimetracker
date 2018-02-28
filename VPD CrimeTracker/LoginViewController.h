//
//  LoginViewController.h
//  VPD CrimeTracker
//
//  Created by Michael Nguyen on 2013-03-02.
//  Copyright (c) 2013 Resursive Industries. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *usernameTextBox;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextBox;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (strong, nonatomic) IBOutlet UISwitch *rememberMeSwitch;


- (IBAction)loginIsPressed:(id)sender;
- (IBAction)registerIsPressed:(id)sender;
- (IBAction)debuggerIsPressed:(id)sender;
- (IBAction)useOfflineIsPressed:(id)sender;



@end

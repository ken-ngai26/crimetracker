//
//  RegisterViewController.h
//  VPD CrimeTracker
//
//  Created by Michael Nguyen on 2013-03-05.
//  Copyright (c) 2013 Resursive Industries. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

//Text Field boxes for Registration

@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmEmailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;


- (IBAction)registerIsPressed:(id)sender;


@end

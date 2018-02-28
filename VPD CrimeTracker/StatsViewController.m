//
//  StatsViewController.m
//  VPD CrimeTracker
//
//  Created by Michael Nguyen on 2013-02-04.
//  Copyright (c) 2013 Resursive Industries. All rights reserved.
//

#import "StatsViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "Reachability.h"

@interface StatsViewController ()

@end

@implementation StatsViewController

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
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    //the code used for open local html file in uivebview
    
    // Check internet Connection
    if ([self connected] == YES) {
        
        //NSURL *url = [NSURL URLWithString:@"http://soulshunters.host-ed.me/chart.html"];
        
        
        
        //NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //[self.statWebView loadRequest:request];
        
        NSString *htmlString = [[NSBundle mainBundle] pathForResource:@"chart" ofType:@"html"];
        NSURL *url = [NSURL fileURLWithPath:htmlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.statWebView loadRequest:request];
        
    }
    else {
        NSLog(@"Error, no internet!!");
            UIAlertView* noInternet = [[UIAlertView alloc]initWithTitle:@"Error"
                                                            message:@"No Internet Connection Found. Please try again when you have internet"
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

@end

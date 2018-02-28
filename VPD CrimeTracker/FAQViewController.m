//
//  FAQViewController.m
//  VPD CrimeTracker
//
//  Created by Michael Nguyen on 2013-02-04.
//  Copyright (c) 2013 Resursive Industries. All rights reserved.
//

#import "FAQViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface FAQViewController ()

@end
@implementation FAQViewController
@synthesize webView; 


//Synthesizers
@synthesize menuBtn = _menuBtn;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//the code needed for open in safari

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSURL *requestURL =[ [ request URL ] retain ];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL: [ requestURL autorelease ] ];
    }
    [ requestURL release ];
    return YES;
}

//the code needed for open in safari
/*-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}*/

- (void)viewDidLoad
{
    //the code needed to open in safari
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //the code used for open local html file in uivebview
    
    NSString *htmlString = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:htmlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];

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
    
    
    // sets the button
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuBtn.frame = CGRectMake(10, 10, 50, 50);
    [self.menuBtn setBackgroundImage:[UIImage imageNamed:@"iconRetina.png"] forState:UIControlStateNormal];
    [self.menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.menuBtn];
    
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

- (IBAction)menuButtonIsPressed:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end

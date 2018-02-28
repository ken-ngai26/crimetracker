//
//  FAQViewController.h
//  VPD CrimeTracker
//
//  Created by Michael Nguyen on 2013-02-04.
//  Copyright (c) 2013 Resursive Industries. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAQViewController : UIViewController{
    IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutlet UIButton *menuBtn;


- (IBAction)menuButtonIsPressed:(id)sender;

@end

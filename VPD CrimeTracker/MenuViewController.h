//
//  MenuViewController.h
//  VPD CrimeTracker
//
//  Created by Michael Nguyen on 2013-01-31.
//  Copyright (c) 2013 Resursive Industries. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UITableViewController

@property (strong, nonatomic) UIButton* homeButton;
@property (strong, nonatomic) UIButton* disorderlyReportButton;
@property (strong, nonatomic) UIButton* reportingHistoryButton;
@property (strong, nonatomic) UIButton* crimeMapButton;
@property (strong, nonatomic) UIButton* statsButton;
@property (strong, nonatomic) UIButton* faqButton;

-(void) changeViewToHome;
-(void) changeViewToDisorderlyReport;
-(void) changeViewToReportingHistory;
-(void) changeViewToCrimeMap;
-(void) changeViewToStats;
-(void) changeViewToFaq;
-(void) changeViewToLogin;




@end

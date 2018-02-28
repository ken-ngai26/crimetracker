//
//  MenuViewController.m
//  VPD CrimeTracker
//
//  Created by Michael Nguyen on 2013-01-31.
//  Copyright (c) 2013 Resursive Industries. All rights reserved.
//

#import "MenuViewController.h"
#import "ECSlidingViewController.h"
#import "LoginViewController.h"

@interface MenuViewController ()

@property (strong, nonatomic) NSArray* menu;

@end

@implementation MenuViewController

@synthesize menu = _menu;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.menu = [NSArray arrayWithObjects:@"Home", @"Disorderly Reporting", @"Reporting History", @"Crime Map", @"Stats", @"FAQ", nil];
    
    
    [self.slidingViewController setAnchorRightRevealAmount:200.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    // sets backgorund image of view
    [self.tableView setBackgroundColor:[UIColor darkGrayColor]];
    
    // disables the scrolling
    self.tableView.scrollEnabled = NO;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.oo
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.menu objectAtIndex:indexPath.row]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    if (indexPath.row == 0){
        
        // sets the button inside the UItableViewCell
        self.homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.homeButton.frame = CGRectMake(0, 0, 200, 60);
        [self.homeButton setBackgroundImage:[UIImage imageNamed:@"homebutton.png"] forState:UIControlStateNormal];
        [self.homeButton addTarget:self action:@selector(changeViewToHome) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.homeButton];
        
    }
    else if (indexPath.row == 1){
        // sets the button inside the UItableViewCell
        
        self.disorderlyReportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.disorderlyReportButton.frame = CGRectMake(0, 60, 200, 60);
        [self.disorderlyReportButton setBackgroundImage:[UIImage imageNamed:@"reportbutton.png"] forState:UIControlStateNormal];
        [self.disorderlyReportButton addTarget:self action:@selector(changeViewToDisorderlyReport) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.disorderlyReportButton];
         
    }
    else if (indexPath.row == 2){
        // sets the button inside the UItableViewCell
        self.reportingHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.reportingHistoryButton.frame = CGRectMake(0, 120, 200, 60);
        [self.reportingHistoryButton setBackgroundImage:[UIImage imageNamed:@"historybutton.png"] forState:UIControlStateNormal];
        [self.reportingHistoryButton addTarget:self action:@selector(changeViewToReportingHistory) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.reportingHistoryButton];
    }
    else if (indexPath.row == 3){
        // sets the button inside the UItableViewCell
        self.crimeMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.crimeMapButton.frame = CGRectMake(0, 180, 200, 60);
        [self.crimeMapButton setBackgroundImage:[UIImage imageNamed:@"mapbutton.png"] forState:UIControlStateNormal];
        [self.crimeMapButton addTarget:self action:@selector(changeViewToCrimeMap) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.crimeMapButton];
    }
    else if (indexPath.row == 4){
        // sets the button inside the UItableViewCell
        self.statsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.statsButton.frame = CGRectMake(0, 240, 200, 60);
        [self.statsButton setBackgroundImage:[UIImage imageNamed:@"statsbutton.png"] forState:UIControlStateNormal];
        [self.statsButton addTarget:self action:@selector(changeViewToStats) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.statsButton];
    }
    else if (indexPath.row == 5){
        // sets the button inside the UItableViewCell
        self.faqButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.faqButton.frame = CGRectMake(0, 300, 200, 60);
        [self.faqButton setBackgroundImage:[UIImage imageNamed:@"faqbutton.png"] forState:UIControlStateNormal];
        [self.faqButton addTarget:self action:@selector(changeViewToFaq) forControlEvents:UIControlEventTouchUpInside];
        
        // Creating logoutbutton
        UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutButton.frame = CGRectMake(0, 360, 200, 60);
        [logoutButton setBackgroundImage:[UIImage imageNamed:@"logoffbutton.png"] forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(changeViewToLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:logoutButton];
        
        UIImage *bottomImage = [UIImage imageNamed:@"bottombackground.png"];
        UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 420, 200, 140)];
        bottomImageView.image = bottomImage;
        [self.view addSubview:bottomImageView];
        
        [self.view addSubview:self.faqButton];
    }
    
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menu objectAtIndex:indexPath.row]];
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
    
    
    
        
    
}


// FUNCTIONS TO CHANGE THE TOP VIEW 
-(void) changeViewToHome {
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menu objectAtIndex:0]];
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

// NextFunctions just change the view to the corresponding ID

-(void) changeViewToDisorderlyReport {
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menu objectAtIndex:1]];
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}
-(void) changeViewToReportingHistory {
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menu objectAtIndex:2]];
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
    
}
-(void) changeViewToCrimeMap {
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menu objectAtIndex:3]];
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
    
}
-(void) changeViewToStats {
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menu objectAtIndex:4]];
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
    
}
-(void) changeViewToFaq {
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menu objectAtIndex:5]];
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
    
}


// UIAlertView Delegate method - checks what to do with specific alerts that are called
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            // Cancel is pressed - do nothing
            NSLog(@"Logout cancelled");
            
        }
        else {
            // Actually log out
            LoginViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            
            
            // Change the view to Disorderly Report
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }
    }
    
}

// Logout and change the view to the Login Screen
-(void) changeViewToLogin {
    
    // Reset user Settings - add later
    
    // Change View
    
    
    // Displays the alert to get the users title before saving into memory
    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to logout from CrimeTrackers?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    logoutAlert.tag = 100;
    [logoutAlert show];

}

@end

//
//  HistoryViewController.m
//  VPD CrimeTracker
//
//  Created by Michael Nguyen on 2013-02-04.
//  Copyright (c) 2013 Resursive Industries. All rights reserved.
//

#import "HistoryViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "DisorderlyReportingViewController.h"
#import <QuartzCore/QuartzCore.h>



@interface HistoryViewController () {
    
     // File location Parameters
     NSArray *paths;
     NSString *docDir;
     NSString *filePath;
     int BLOCKINGFACTOR;
    
    NSArray *historyTitle;
    
    NSData *userInformationFromFile;
    NSArray *userInformation;
    
    NSString *currentUserLogin;
    
}
@property (strong, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation HistoryViewController

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
    
    historyTitle = [[NSArray alloc] init];
    
    // sets the background to an image
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"final-bg.jpg"]];
    
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
    
    
    fileManager = [NSFileManager defaultManager];
     
    // Obtaining the file location
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docDir = [paths objectAtIndex:0];
    
    // Recieving user information. ie. login details
    userInformationFromFile = [[NSData alloc] initWithContentsOfFile:[docDir stringByAppendingString:@"/UserInformation.txt"]];
    userInformation = [NSKeyedUnarchiver unarchiveObjectWithData:userInformationFromFile];
    
    currentUserLogin = [userInformation objectAtIndex:0];
    
    filePath = [docDir stringByAppendingFormat:@"/%@VPDUserInformation.txt", currentUserLogin];
    NSLog(@"File Path: %@",filePath);
    
    // Set the blocking factor
     BLOCKINGFACTOR = 6;

    //Creating the table rows
    
    // Get the current information from the file
    NSData *dataFromFile = [[NSData alloc] initWithContentsOfFile:filePath];
    NSArray *arrayFromFile = [NSKeyedUnarchiver unarchiveObjectWithData:dataFromFile];
    //NSLog(@"Array from memory: %@", arrayFromFile);
    
    int numberOfReports = [HistoryViewController numberOfReports:arrayFromFile blockingFactor:BLOCKINGFACTOR];
    NSLog(@"The number of reports is: %d", numberOfReports);
    
    for (int i=0;i<numberOfReports; i++) {
        NSArray *report = [HistoryViewController reportArray:arrayFromFile atIndex:i blockingFactor:BLOCKINGFACTOR];
        
        //NSLog(@"Current Array is: %@", report);

        
        historyTitle = [historyTitle arrayByAddingObject:[report objectAtIndex:0]];
        //NSLog(@"History title is: %@", historyTitle);
    }
    
    
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


// Debugger - for testing
- (IBAction)newReportIsPressed:(id)sender {
    NSString *identifier = @"Disorderly Reporting";
    
    DisorderlyReportingViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    // Change the view to Disorderly Report
    CGRect frame = self.slidingViewController.topViewController.view.frame;
    self.slidingViewController.topViewController = newTopViewController;
    self.slidingViewController.topViewController.view.frame = frame;
    [self.slidingViewController resetTopView];
}

- (IBAction)debuggerIsPressed:(id)sender {   
    
}


// will return the disorderly report giving at index
+ (NSArray*) reportArray:(NSArray*)reportArray atIndex:(int)index blockingFactor:(int)blockingFactor {
    
    int length = [reportArray count];
    int maxIndex = (length / blockingFactor) - 1;
    //NSLog(@"Running report array");

    //NSLog(@"The Length %d, the maxindex : %d", length, maxIndex);
    if (index<=maxIndex) {
        int start = blockingFactor * index;
        
        NSArray *newArray = [reportArray subarrayWithRange:NSMakeRange(start, blockingFactor)];
        
        return newArray;
        
    }
    else {
        NSLog(@"The index is out of bounds - nothing is returned");
        
        return nil;
    }
}


// Return the number of reports given in the total array
+ (int) numberOfReports:(NSArray*)reportArray blockingFactor:(int)blockingFactor{
    int length = [reportArray count];
    int numberOfReports = (length / blockingFactor) - 1;
    
    return numberOfReports + 1;
}

// Deletes a report index and replaces its position with the end arrays.
+ (NSArray*) deleteReport:(NSArray*)reportArray atIndex:(int)index withBlockingFactor:(int)blockingFactor {
    
    NSArray *finalArray;
    
    if ((index <= [HistoryViewController numberOfReports:reportArray blockingFactor:blockingFactor]) && (index >= 0)) {
        
        // Start and final end length
        int start = index * blockingFactor;
        int length = [reportArray count] - ((index + 1) * blockingFactor);
        
        NSArray *firstArray = [reportArray subarrayWithRange:NSMakeRange(0, start)];
        NSArray *secondArray = [reportArray subarrayWithRange:NSMakeRange(start + blockingFactor, length)];
        
        NSMutableArray *mutFirst = [NSMutableArray arrayWithArray:firstArray];
        NSMutableArray *mutSecond = [NSMutableArray arrayWithArray:secondArray];
        
        NSMutableArray *mutFinalArray = [[NSMutableArray alloc] initWithArray:mutFirst];
        [mutFinalArray addObjectsFromArray:mutSecond];
        
        //NSLog(@"First Array: %@, second Array: %@", firstArray, secondArray);
        
        finalArray = [[NSArray alloc] initWithArray:mutFinalArray];
        //NSLog(@"Final Array: %@ With Size: %d", finalArray, [finalArray count]);
        
        return finalArray;
        
    }
    else {
        NSLog(@"The index is out of bounds - nothing is returned");
        return nil;
        
    }
    
}

// deletes report and automatically saves the new array to file
-(void) deleteReport:(NSArray*)arrayReport atIndex:(int)index withBlockingFactor:(int)blockingFactor saveToFile:(NSString*)file {
    
    int maxIndex = [HistoryViewController numberOfReports:arrayReport blockingFactor:blockingFactor];
    
    if ((index <= maxIndex) && (maxIndex>=0)) {
        // Save the array back to the file
        NSArray *updatedArray = [HistoryViewController deleteReport:arrayReport atIndex:index withBlockingFactor:blockingFactor];
        
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:updatedArray];
        [data writeToFile:file atomically:YES];
    }
    else {
        NSLog(@"The index was out of bounds therefore delete report did not finish executing");
    }
    
}

// returns the number of rows in the table
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [historyTitle count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// Inititializing the table view cell
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // Sets the arrow on the right side of the cell
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Get the current disorderly report information from the file
    NSData *dataFromFile = [[NSData alloc] initWithContentsOfFile:filePath];
    NSArray *arrayFromFile = [NSKeyedUnarchiver unarchiveObjectWithData:dataFromFile];
    //NSLog(@"Array from memory: %@", arrayFromFile);
    
    
    //NSLog(@"the indexpath is: %d", indexPath.row);
    
    NSArray *selectedArray = [HistoryViewController reportArray:arrayFromFile atIndex:indexPath.row blockingFactor:BLOCKINGFACTOR];
    
    // Retrieving strings from array
    NSString *cellText = [historyTitle objectAtIndex:indexPath.row];
    NSString *cellSubtitleText = [selectedArray objectAtIndex:2];
    
    // Set cell Label Text
    cell.textLabel.text = cellText;
    
    // Set Cell Subtitle Text
    cell.detailTextLabel.text = cellSubtitleText;
    
    // Set the Cell image
    
    NSData *selectedArrayImage = [selectedArray objectAtIndex:5]; // Get the picture From the array
    UIImage *selectedImage = [UIImage imageWithData:selectedArrayImage];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    //imgView.backgroundColor = [UIColor clearColor];
    [imgView.layer setCornerRadius:1.0f];
    [imgView.layer setMasksToBounds:YES];
    [imgView setImage:selectedImage];
    [cell.contentView addSubview:imgView];
    
    
    cell.imageView.image = [UIImage imageNamed:@"transparency.png"];
    
    return cell;
    
}


// What to do when a row is pressed
-(void ) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"the indexpath is: %d", indexPath.row);
    
    // Storing history report information into a local file
    
    NSString *shouldILoadReportData = @"1";
    NSString *historyReportNumber = [NSString stringWithFormat:@"%d", indexPath.row];
    
    NSArray *historyArray = [[NSArray alloc] initWithObjects:shouldILoadReportData, historyReportNumber, nil];
    
    // end of file information
    
    NSString *identifier = @"Disorderly Reporting";
    
    DisorderlyReportingViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    // Push information to Disorderly Report
    newTopViewController.informationHistoryArray = historyArray;
    
    // Change the view to Disorderly Report
    CGRect frame = self.slidingViewController.topViewController.view.frame;
    self.slidingViewController.topViewController = newTopViewController;
    self.slidingViewController.topViewController.view.frame = frame;
    [self.slidingViewController resetTopView];

}



-(void) changeViewToDisorderlyReport {
    NSString *identifier = @"Disorderly Reporting";
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}



@end

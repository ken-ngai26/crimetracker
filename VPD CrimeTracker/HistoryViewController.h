//
//  HistoryViewController.h
//  VPD CrimeTracker
//
//  Created by Michael Nguyen on 2013-02-04.
//  Copyright (c) 2013 Resursive Industries. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSFileManager *fileManager;
    
}
@property (strong, nonatomic) IBOutlet UITableView *historyTable;
- (IBAction)newReportIsPressed:(id)sender;


- (IBAction)debuggerIsPressed:(id)sender;
- (void)deleteReport:(NSArray*)arrayReport atIndex:(int)index withBlockingFactor:(int)blockingFactor saveToFile:(NSString*)file;

+ (int) numberOfReports:(NSArray*)reportArray blockingFactor:(int)blockingFactor;

+ (NSArray*) reportArray:(NSArray*) reportArray atIndex:(int)index blockingFactor:(int)blockingFactor;

+ (NSArray*) deleteReport:(NSArray*)reportArray atIndex:(int)index withBlockingFactor:(int)blockingFactor;

-(void) changeViewToDisorderlyReport;


@end


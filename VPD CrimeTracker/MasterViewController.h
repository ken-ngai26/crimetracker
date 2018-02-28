//
//  MasterViewController.h
//  Twitter Test
//
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController {
    UIRefreshControl *refresh;
    NSArray *tweets;
}
- (BOOL)connected;
- (void)fetchTweets;
- (void)refresh;

@end

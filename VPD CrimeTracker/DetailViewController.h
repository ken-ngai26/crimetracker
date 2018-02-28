//
//  DetailViewController.h
//  Twitter Test
//
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
    IBOutlet UIImageView *profileImage;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *tweetLabel;
}

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;



@end

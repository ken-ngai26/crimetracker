//
//  MasterViewController.m
//  Twitter Test
//
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SystemConfiguration/SystemConfiguration.h"
#import "Reachability.h"


@implementation MasterViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
//*****************************************
- (BOOL)connected // Checks for internet connection
{
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.ca"];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}
- (void)viewDidLoad
{
    //Pull Down to Refresh Code
    refresh = [[UIRefreshControl alloc]init];
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refresh)forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    if(![self connected]){
        NSLog(@"No Internet");
        UIAlertView* noInternet = [[UIAlertView alloc]initWithTitle:@"No Internet Connection Detected"
                                                            message:@"The application will proceed without internet."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [noInternet show];
    }
    else{
        NSLog(@"Internet Detected");
        NSLog(@"Fetching Tweets.....");
        [self fetchTweets];
    }
}

- (void)refresh //Refresh Table View
{
    if(![self connected]){
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"No Internet Connection"];
        [self.refreshControl endRefreshing];
    }
    else{
        //Title when refreshing
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing"];
        NSDateFormatter *formattedDate = [[NSDateFormatter alloc]init];
        [formattedDate setDateFormat:@"MMM d, h:mm a"];
        NSString *lastupdated = [NSString stringWithFormat:@"Last Updated on %@",[formattedDate stringFromDate:[NSDate date]]];
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:lastupdated];
        [self fetchTweets]; //reload tweets
        [self.refreshControl endRefreshing];
    }


    
    
}
- (void)fetchTweets //Get Latest Tweets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Wrap twitter url in NSData
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: @"https://api.twitter.com/1/statuses/user_timeline.json?include_entities=true&screen_name=VancouverPD"]];
        
        NSError* error;
        //Parse JSON info from data
        tweets = [NSJSONSerialization JSONObjectWithData:data
                                                 options:kNilOptions 
                                                   error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //Load Parsed Tweets into TableView
            [self.tableView reloadData];
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Get "text" from Parsed JSON
    NSDictionary *tweet = [tweets objectAtIndex:indexPath.row];    
    NSString *text = [tweet objectForKey:@"text"];
    NSString *detailText = [tweet objectForKey:@"created_at"];
    detailText = [detailText substringToIndex:19];
    //Put text and Vancouver Police Logo onto the label on the table cell
    cell.textLabel.text = text;
    cell.detailTextLabel.text = detailText;
    cell.imageView.image = [UIImage imageNamed:@"VPDLogo.png"];
    
    
    return cell;
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender // Segue to DetailViewController
{
    if ([segue.identifier isEqualToString:@"showTweet"]) {
        
        NSInteger row = [[self tableView].indexPathForSelectedRow row];
        NSDictionary *tweet = [tweets objectAtIndex:row];
        
        DetailViewController *detailController = segue.destinationViewController;
        detailController.detailItem = tweet;
    }
}


@end

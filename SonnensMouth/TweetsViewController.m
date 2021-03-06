//
//  TweetsViewController.m
//  SonnensMouth
//
//  Created by david lam on 4/16/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "TweetsViewController.h"

@implementation TweetsViewController

@synthesize tweets;



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:TWEETS_API_URL]];
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:req delegate:self];
    [conn start];    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    
    if ([tweets count] > 0) {
        return [tweets count];
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";

    // hardcoded in storyboard
    static NSString *CellIdentifier = @"tweets reuse cell identifier"; 
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if([tweets count] == 0) {
        cell.textLabel.text = @"Loading tweets...";  
    }
    else {
        NSDictionary *tweet = [tweets objectAtIndex:indexPath.row];
        
        NSString *createdAt = [tweet objectForKey:@"created_at"];
        NSString *text      = [tweet objectForKey:@"text"];        
        NSString *createdAtString = [self dateDiff:createdAt];
        
        cell.textLabel.text      = [NSString stringWithFormat:@"%@\n%@", createdAtString, text];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }

//    cell.textLabel.text = [NSString stringWithFormat:@"Cell #%d", indexPath.row];
    
    return cell;
}

/*
    TODO  5/15/12   Calculate cell height so that it fits all of the tweet text!
 
 */
-(CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tv cellForRowAtIndexPath:indexPath];
    
    NSString *text = cell.textLabel.text; //[[menuList objectAtIndex:indexPath.row] objectForKey:@"status"];
    CGFloat height = [text sizeWithFont:cell.textLabel.font constrainedToSize:CGSizeMake(240,70) lineBreakMode:UILineBreakModeWordWrap].height;
    //return MAX(height, MinHeight);
    
    return height+30;     
}

/*
 
    "created_at":"Sun Apr 15 05:06:03 +0000 2012",

    from http://stackoverflow.com/questions/902950/iphone-convert-date-string-to-a-relative-time-stamp 
 */
-(NSString *)dateDiff:(NSString *)origDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//  [df setDateFormat:@"EEE, dd MMM yy HH:mm:ss VVVV"];       // Thu, 21 May 09 19:10:09 -0700
    [df setDateFormat:@"EEE MMM dd HH:mm:ss VVVV yyyy"];      // Sun Apr 15 05:06:03 +0000 2012
    NSDate *convertedDate = [df dateFromString:origDate];     
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"never";
    } else      if (ti < 60) {
        return @"less than a minute ago";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d minutes ago", diff, diff == 1 ? @"minute" : @"minutes"];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d %@ ago", diff, diff == 1 ? @"hour" : @"hours"];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d %@ ago", diff, diff == 1 ? @"day" : @"days"];
    } else {
        NSDateFormatter *dayAndMonthFormat = [[NSDateFormatter alloc] init];
        [dayAndMonthFormat setDateFormat:@"dd MMM"];            
        return [dayAndMonthFormat stringFromDate:convertedDate];        
    }   
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
}

#pragma mark - <NSURLConnection> delegate methods

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
//    DebugLog(@" response code: %d ", code);
    
    if(code != 200) {        
        // then it failed or sumthin...
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    // this will return the webpage HTML at the URL for example!    
//        NSString *serverResponse = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
//    DebugLog(@"serverResponse: %@", serverResponse);

    if(!tweetsData)
        tweetsData = [NSMutableData dataWithData:theData];
    else
        [tweetsData appendData:theData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSError *error;
    tweets = [NSJSONSerialization JSONObjectWithData:tweetsData options:kNilOptions error:&error];
    [tableView reloadData];
    [tableView setNeedsDisplay];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    UIAlertView *av = [SonnensMouth newNoInternetConnectionAlertView];    
    [av show];
}



#pragma mark - IBAction's

-(IBAction)openInSafari:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/sonnench"]];
}

-(IBAction)done:(id)sender
{
    SaidSoViewController *s = [[[self tabBarController] viewControllers] objectAtIndex:1];
    [s done:sender];
}

@end

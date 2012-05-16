//
//  MoreViewController.m
//  SonnensMouth
//
//  Created by David Lam on 4/23/12.
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

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

    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    switch (indexPath.row) {
        case VOICE_OF_REASON_ROW:
            cell.textLabel.text = @"Buy Chael's book";
            break;
            
        case FIGHT_RECORD_ROW:
            cell.textLabel.text = @"Fight Record";
            break;
/*            
        case DIRECTORY_LIST_ROW:
            cell.textLabel.text = @"Directory List";
            break;
*/            
        case ABOUT_LIST_ROW:
            cell.textLabel.text = @"About";
            break;
            
        default:
            cell.textLabel.text = @"";
            break;
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
        
    switch (indexPath.row) {    
            
        case VOICE_OF_REASON_ROW:            
            [self showBookWebView];            
            break;
            
        case FIGHT_RECORD_ROW:
            [self showFightRecordWebView];
            break;

            
            /*
        case DIRECTORY_LIST_ROW:
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:IDENTIFIER_DIRECTORY_LIST] animated:YES];            
            self.navigationItem.title = @"Directory List";
            break;
             */
        case ABOUT_LIST_ROW:            
            [self showAboutView];
            break;
        default:
            DebugLog(@"Doh, entered default of switch()");
            break;
    }
}

#pragma mark - IBAction's

- (IBAction)done:(id)sender
{
    ActionsViewController *avc = (ActionsViewController *)[self tabBarController];    
    [[avc actionsDelegate] actionsViewControllerDidFinish:avc];
}

-(void)showAboutView
{
    UIViewController *aboutController = [self.storyboard instantiateViewControllerWithIdentifier:@"About"];    
    aboutController.title = @"About";
    [self.navigationController pushViewController:aboutController animated:YES];
}

-(void)showBookWebView
{
    [self showWebViewAt:@"http://www.amazon.com/The-Voice-Reason-V-I-P-Enlightenment/dp/1936608545" withTitle:@"Chael's Book"];
}

-(void)showFightRecordWebView
{
//    NSString *sherdogURL = @"http://m.sherdog.com/fighter/Chael-Sonnen-4112";
    NSString *sherdogRecordURL = @"http://m.sherdog.com/fighter/record/Chael-Sonnen-4112";
    
    [self showWebViewAt:sherdogRecordURL withTitle:@"Fight Record"];
}

-(void)showWebViewAt:(NSString *)address withTitle:(NSString *)title
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
    
    webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [webView loadRequest:request];
    
    webViewController = [[UIViewController alloc] init];
    webViewController.view = webView;
    webViewController.title = title;
    
    webViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Open in Safari" style:UIBarButtonItemStyleBordered target:self action:@selector(openInSafari)];    

    
    [self.navigationController pushViewController:webViewController animated:YES]; 
}

-(void)openInSafari
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[webView.request URL].absoluteString]];
}

#pragma mark - <UIWebViewDelegate>

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    UIAlertView *av = [SonnensMouth newNoInternetConnectionAlertView];    
    [av show];
}


@end

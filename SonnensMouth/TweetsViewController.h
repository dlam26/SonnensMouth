//
//  TweetsViewController.h
//  SonnensMouth
//
//  Created by david lam on 4/16/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "SonnensMouth.h"


//@interface TweetsViewController : UITableViewController <NSURLConnectionDelegate>
@interface TweetsViewController : UIViewController <NSURLConnectionDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray *tweets;
    NSMutableData *tweetsData;
    
    IBOutlet UITableView *tableView;
}

@property(nonatomic,retain) NSArray *tweets;

-(NSString *)dateDiff:(NSString *)origDate;

-(IBAction)openInSafari:(id)sender;

@end

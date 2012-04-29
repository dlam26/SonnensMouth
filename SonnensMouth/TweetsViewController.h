//
//  TweetsViewController.h
//  SonnensMouth
//
//  Created by david lam on 4/16/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

//  4/29/12  whoa, Apple has built-in twitter frameowrk?! 
//      http://developer.apple.com/library/ios/#samplecode/Tweeting/Introduction/Intro.html
//      https://dev.twitter.com/docs/ios


#import <UIKit/UIKit.h>

//#import <Twitter/TWRequest.h>
//#import <Twitter/TWTweetComposeViewController.h>

#import "SonnensMouth.h"
#import "SaidSoViewController.h"



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

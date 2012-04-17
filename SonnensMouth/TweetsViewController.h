//
//  TweetsViewController.h
//  SonnensMouth
//
//  Created by david lam on 4/16/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "SonnensMouth.h"


@interface TweetsViewController : UITableViewController <NSURLConnectionDelegate>
{
    NSArray *tweets;
    
    NSMutableData *tweetsData;
}

@property(nonatomic,retain) NSArray *tweets;

-(NSString *)dateDiff:(NSString *)origDate;

@end

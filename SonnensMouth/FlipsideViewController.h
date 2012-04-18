//
//  FlipsideViewController.h
//  SonnensMouth
//
//  Created by david lam on 4/3/12   .
//  Copyright (c) 2012 das. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SonnensMouth.h"

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController
{
    IBOutlet id <FlipsideViewControllerDelegate> delegate;

}

@property (weak, nonatomic) IBOutlet id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end

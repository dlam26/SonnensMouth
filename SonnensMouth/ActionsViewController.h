//
//  ActionsViewController.h
//  SonnensMouth
//
//  Created by david lam on 4/18/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaidSoViewController.h"

@class ActionsViewController;

@protocol ActionsViewControllerDelegate <NSObject>
-(void)actionsViewControllerDidFinish:(ActionsViewController *)controller;    
@end

@interface ActionsViewController : UITabBarController
{
    IBOutlet id <ActionsViewControllerDelegate> actionsDelegate;
    
    UIInterfaceOrientation newOrientation;
    
}

@property (weak, nonatomic) IBOutlet id <ActionsViewControllerDelegate> actionsDelegate;

- (IBAction)done:(id)sender;

@end

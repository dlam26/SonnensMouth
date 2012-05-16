//
//  AboutViewController.h
//  SonnensMouth
//
//  Created by david lam on 5/16/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "SonnensMouth.h"

@interface AboutViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    
    IBOutlet UILabel *appVersion;
    
    MFMailComposeViewController *mailCompose;
}

-(IBAction)sendFeedback:(id)sender;


@end

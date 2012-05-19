//
//  AboutViewController.h
//  SonnensMouth
//
//  Created by david lam on 5/16/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>
#import "SonnensMouth.h"

@interface AboutViewController : UIViewController <MFMailComposeViewControllerDelegate, AVAudioRecorderDelegate> {
    
    IBOutlet UILabel *appVersion;
    
    MFMailComposeViewController *mailCompose;
    
    AVAudioRecorder *recorder;
    
    IBOutlet UIButton *recordNameButton;
    IBOutlet UIButton *playNameButton;
    IBOutlet UILabel *recordingLabel;
}

-(IBAction)sendFeedback:(id)sender;

-(IBAction)recordName:(id)sender;
-(IBAction)playName:(id)sender;

@end

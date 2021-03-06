//
//  EditRecordedInsultViewController.h
//  SonnensMouth
//
//  Created by david lam on 4/25/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>

#import "SonnensMouth.h"
#import "Barrage.h"
#import "RecordedInsultsViewController.h"

@interface EditRecordedInsultViewController : UIViewController <MFMailComposeViewControllerDelegate, UITextFieldDelegate, EmailBarrageDelegate> {
    
    IBOutlet UITextField *titleTextField;
    IBOutlet UILabel *createdDateLabel;
    IBOutlet UILabel *updatedDateLabel;
    IBOutlet UILabel *lengthLabel;
    IBOutlet UILabel *soundsCountLabel;
    IBOutlet UILabel *messageQueuedLabel;
    IBOutlet UIButton *deleteButton;
    IBOutlet UIButton *emailButton;
    IBOutlet UIButton *playButton;
    
    UIBarButtonItem *stopPlayingRecordingButton;
    
    MFMailComposeViewController *mailCompose;
    
    Barrage *barrage;
    
    BOOL doneExporting;
    NSData *barrageData;
}

@property(nonatomic, retain) Barrage *barrage;

-(void)hideInputsAndSave;
-(IBAction)email:(id)sender;
-(IBAction)play:(id)sender;
-(IBAction)saveDetails:(id)sender;
-(IBAction)deleteRecording:(id)sender;


@end

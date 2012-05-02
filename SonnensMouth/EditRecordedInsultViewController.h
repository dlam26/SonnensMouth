//
//  EditRecordedInsultViewController.h
//  SonnensMouth
//
//  Created by david lam on 4/25/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "SonnensMouth.h"
#import "Barrage.h"
#import "RecordedInsultsViewController.h"

@interface EditRecordedInsultViewController : UIViewController <MFMailComposeViewControllerDelegate, UITextFieldDelegate> {
    
    IBOutlet UITextField *titleTextField;
    IBOutlet UILabel *createdDateLabel;
    IBOutlet UILabel *updatedDateLabel;
    IBOutlet UILabel *lengthLabel;
    IBOutlet UILabel *soundsCountLabel;
    IBOutlet UIButton *deleteButton;
    
    UIBarButtonItem *stopPlayingRecordingButton;
    
    MFMailComposeViewController *mailCompose;
    
    Barrage *barrage;
}

@property(nonatomic, retain) Barrage *barrage;

-(void)hideInputsAndSave;
-(IBAction)email:(id)sender;
-(IBAction)play:(id)sender;
-(IBAction)saveDetails:(id)sender;
-(IBAction)deleteRecording:(id)sender;

@end

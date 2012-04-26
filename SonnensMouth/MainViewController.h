//
//  MainViewController.h
//  SonnensMouth
//
//  Created by david lam on 4/3/12   .
//  Copyright (c) 2012 das. All rights reserved.
//


#import "ActionsViewController.h"
#import "PlaySoundUIButton.h"
#import "PlayedSound.h"
#import "NSManagedObject+Barrage.h"
#import "NSManagedObject+PlayedSound.h"

@interface MainViewController : UIViewController <ActionsViewControllerDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate>
{
    IBOutlet UIImageView *background;
    IBOutlet UISwitch *recordingSwitch;
    IBOutlet UILabel *recordingLabel;
    
    UIImage *smilingChael;
    UIImage *bustedUpChael;
    
    BOOL isRecording;
    NSMutableArray *playedSounds;
    NSDate *recordStart;
    
    CGRect originalButtonFrame;
    
    ActionsViewController *actionsViewController;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

-(IBAction)makeButtonTextBig:(id)sender;
-(IBAction)makeButtonTextSmall:(id)sender;
-(IBAction)playSound:(id)sender;

-(IBAction)toggleRecording:(id)sender;
-(void)showSaveRecordingActionSheet;
-(void)previewRecording;

-(CGFloat)calculateRightBound:(UIButton *)button;

@end

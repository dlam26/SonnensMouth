//
//  MainViewController.h
//  SonnensMouth
//
//  Created by david lam on 4/3/12   .
//  Copyright (c) 2012 das. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import "FlipsideViewController.h"
#import "ActionsViewController.h"
#import "PlaySoundUIButton.h"


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, ActionsViewControllerDelegate, UIPopoverControllerDelegate>
{
    IBOutlet UIImageView *background;
    IBOutlet UISwitch *backgroundSwitch;
    
    UIImage *smilingChael;
    UIImage *bustedUpChael;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

-(IBAction)switchBackground:(id)sender;
-(IBAction)makeButtonTextBig:(id)sender;
-(IBAction)makeButtonTextSmall:(id)sender;
-(IBAction)playSound:(id)sender;

@end

//
//  RecordedInsultsViewController.h
//  SonnensMouth
//
//  Created by david lam on 4/20/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "AppDelegate.h"
#import "Barrage.h"
#import "SonnensMouth.h"
#import "ActionsViewController.h"
#import "EditRecordedInsultViewController.h"


@interface RecordedInsultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
    
    IBOutlet UITableView *recordings;
    IBOutlet UIBarButtonItem *stopPlayingRecordingButton;
    
    NSFetchedResultsController *fetchedResultController;    
    Barrage *selectedBarage;
}

@property(nonatomic, retain) UITableView *recordings;

- (IBAction)done:(id)sender;
- (IBAction)stopPlayingRecording:(id)sender;
    
@end

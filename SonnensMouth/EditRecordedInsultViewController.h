//
//  EditRecordedInsultViewController.h
//  SonnensMouth
//
//  Created by david lam on 4/25/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SonnensMouth.h"
#import "Barrage.h"
#import "RecordedInsultsViewController.h"

@interface EditRecordedInsultViewController : UIViewController {
    
    IBOutlet UITextField *titleTextField;
    IBOutlet UILabel *createdDateLabel;    
    IBOutlet UILabel *updatedDateLabel; 
    IBOutlet UIButton *deleteButton;
    
    Barrage *barrage;
}

@property(nonatomic, retain) Barrage *barrage;

-(void)hideInputs;
-(IBAction)save:(id)sender;
-(IBAction)play:(id)sender;
-(IBAction)deleteRecording:(id)sender;


@end

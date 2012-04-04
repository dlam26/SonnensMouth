//
//  MainViewController.h
//  SonnensMouth
//
//  Created by david lam on 4/3/12   .
//  Copyright (c) 2012 das. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate>
{
    IBOutlet UIImageView *background;
    IBOutlet UISwitch *backgroundSwitch;
    
    UIImage *smilingChael;
    UIImage *bustedUpChael;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

-(IBAction)switchBackground:(id)sender;

@end

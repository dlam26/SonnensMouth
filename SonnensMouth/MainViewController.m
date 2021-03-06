//
//  MainViewController.m
//  SonnensMouth
//
//  Created by david lam on 4/3/12   .
//  Copyright (c) 2012 das. All rights reserved.
//

#import "MainViewController.h"
#import "SonnensMouth.h"

@implementation MainViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize flipsidePopoverController = _flipsidePopoverController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    NSString *smilingPic = [[NSBundle mainBundle] pathForResource:@"sonnen_smiling" ofType:@"jpg"];
    NSString *messedUpFacePic = [[NSBundle mainBundle] pathForResource:@"sonnen_smiling_messedup" ofType:@"jpg"];
    
    smilingChael  = [UIImage imageWithContentsOfFile:smilingPic];
    bustedUpChael = [UIImage imageWithContentsOfFile:messedUpFacePic];
    
    background.image = smilingChael;
//    background.image = bustedUpChael;
    
    [UIView animateWithDuration:2.0 animations:^{        
        background.layer.opacity = 0.2;
    }];
        
    recordingLabel.textColor = [UIColor grayColor];
    
    /*
     // blur  http://www.dimzzy.com/blog/2010/11/blur-effect-for-uiview/
    [background.layer setRasterizationScale:0.3];
    [background.layer setShouldRasterize:YES];
     */
}
    
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    newInterfaceOrientation = interfaceOrientation;
    
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
        
        return YES;   //  4/24/12  all orientations supported on iphone
    } else {
        return YES;
    }

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    /*
    [UIView animateWithDuration:1.0 animations:^{
        background.layer.opacity = 1.0;
    }];
     */
    
    background.image = background.image == smilingChael ? bustedUpChael : smilingChael;
    
    /*
    [UIView animateWithDuration:1.0 animations:^{
        background.layer.opacity = 0.2;
    }];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
    else if ([[segue identifier] isEqualToString:@"tweets"]) {
        
    }
    else if ([[segue identifier] isEqualToString:IDENTIFIER_SEGUE_TO_ACTIONS_VIEW_CONTROLLER]) {
        
        ActionsViewController *avc = (ActionsViewController *) segue.destinationViewController;
        avc.actionsDelegate = self;
        
        if ([sender class] == [UIActionSheet class]) {
            // then we just saved a recording from MainViewController.m:280
            // ...so open the edit recording page
           
            avc.selectedIndex = 0;
            
            UINavigationController *nav = (UINavigationController *) avc.selectedViewController;
            
            RecordedInsultsViewController *rvc = (RecordedInsultsViewController *) nav.topViewController;
            
            rvc.justPerformedSave = YES;
        }
        else {
            avc.selectedIndex = actionsViewController.selectedIndex;
        }
    }
    else {        
        DebugLog(@"did segue with unknown identifier: %@", [segue identifier]);
    }
}




#pragma mark - ActionsViewController  delegate stuff

-(void)actionsViewControllerDidFinish:(ActionsViewController *)controller
{
    actionsViewController = controller;
    
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -  IBAction's

-(IBAction)toggleRecording:(id)sender
{
    UISwitch *theSwitch = (UISwitch *)sender;
    
    if([theSwitch isOn]) {
        // start recording
        isRecording = YES;
        recordingLabel.text = @"Recording";
        recordingLabel.textColor = [UIColor redColor];        
        playedSounds = [NSMutableArray array];

    }
    else {
        // stop recording
        isRecording = NO;
        recordingLabel.text = @"Not recording";
        recordingLabel.textColor = [UIColor lightGrayColor];        
        if([playedSounds count] > 0) {
            [self showSaveRecordingActionSheet];
        }
    }
    
    // old stuff, when it just changed the background
//    background.image = (background.image == smilingChael) ? bustedUpChael : smilingChael;
}

-(void)showSaveRecordingActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Save recording?" 
                                                             delegate:self 
                                                    cancelButtonTitle:@"Nah"
                                               destructiveButtonTitle:@"Yah, save it"
                                                    otherButtonTitles:@"Preview", nil];
    [actionSheet showInView:self.view];
}

/* 
    Iterates through the played sounds and plays em'!
 */
-(void)previewRecording 
{
    [[SonnensMouth sonnensMouth] playArrayOfSounds:playedSounds withStart:recordStart];
}

/*
    Returns the right bound of the button by calling NSString sizeWithFont  
    on the buttons titleLabel text.
 */
-(CGFloat)calculateRightBound:(UIButton *)button
{
    CGFloat buttonX = button.frame.origin.x;
    CGFloat buttonWidth = [button.titleLabel.text sizeWithFont:button.titleLabel.font].width;
    CGFloat rightBound = buttonX + buttonWidth;
    
//    DebugLog(@"button.frame: %@    buttonX: %f    buttonWidth: %f   rightBound: %f", NSStringFromCGRect(button.frame), buttonX, buttonWidth, rightBound);

    return rightBound;
}

/*
    320 x 480 points
  */
-(IBAction)makeButtonTextBig:(id)sender
{
    UIButton *soundButton = (UIButton *)sender;
    originalButtonFrame = soundButton.frame;
    originalButtonTitleLabelFont = soundButton.titleLabel.font;
    originalButtonColor = soundButton.titleLabel.textColor;

    // make it big
    soundButton.titleLabel.font = [soundButton.titleLabel.font fontWithSize:20.0];
    soundButton.titleLabel.textColor = originalButtonColor;   // FIXME ...dosen't work
    [soundButton sizeToFit];
    
    // Calculate x-axis adjustment so that it dosen't get cut off to the right or left
/*
    CGFloat newRightBound = [self calculateRightBound:soundButton];
    CGFloat adjustment = 0.0;
    CGFloat additionalRightAdjustment = 60.0;
    
    if (newRightBound > 320.0) {
        adjustment = newRightBound - 320.0 + additionalRightAdjustment;
    }
    
    CGRect widerFrame = CGRectMake(originalButtonFrame.origin.x-adjustment, originalButtonFrame.origin.y, originalButtonFrame.size.width*2, originalButtonFrame.size.height);
    
    DebugLog(@"original frame: %@    new frame: %@  newRightBound: %f",
             NSStringFromCGRect(originalButtonFrame), 
             NSStringFromCGRect(widerFrame),
             newRightBound);
    
    soundButton.frame = widerFrame;
*/    
    [self.view bringSubviewToFront:soundButton];

}

-(IBAction)makeButtonTextSmall:(id)sender
{
    UIButton *soundButton = (UIButton *)sender;
    soundButton.titleLabel.font = originalButtonTitleLabelFont;
    soundButton.frame = originalButtonFrame;
}

-(IBAction)playSound:(id)sender
{
    // if a recording is playing via GCD, stop it
    [SonnensMouth sonnensMouth].cancelPlaySound = YES;
    
    PlaySoundUIButton *b = (PlaySoundUIButton *)sender;
    [[SonnensMouth sonnensMouth] playSound:b.soundName];
    
    if (isRecording) {  
        
        id context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];        
        PlayedSound *newPlayedSound = [NSManagedObject insertPlayedSoundWithName:b.soundName orWithSoundData:nil andOrder:[NSNumber numberWithInteger:[playedSounds count]] inManagedObjectContext:context];
        [playedSounds addObject:newPlayedSound];
        
        // 5/20/12  if we're over MAX_RECORDING_SOUNDS, stop recording
        if([playedSounds count] > MAX_RECORDING_SOUNDS) {            

            recordingSwitch.on = NO;
            
            [self toggleRecording:recordingSwitch];
        }
    }
}




#pragma mark - <UIActionSheetDelegate>

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if(buttonIndex == 0) {
        // save it in core data!
        
        id context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
                
        // persist all the played sounds and the barrage!
        
        NSString *newBarrageTitle = @"untitled rant";   // TODO- let user customize       
        
        [NSManagedObject insertBarrageWithTtitle:newBarrageTitle andSounds:[NSSet setWithArray:playedSounds] inManagedObjectContext:context];
        NSError *err = nil;
        
        if(![context save:&err]) {
            DebugLog(@"Error persisting recording: %@", err);
        }
        else {
            // open the edit sound page
            
//            [gotoTabbarButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            [self performSegueWithIdentifier:IDENTIFIER_SEGUE_TO_ACTIONS_VIEW_CONTROLLER sender:actionSheet];
        }
    }
    else if(buttonIndex == 1) {
        // clicked the preview button        
        [self previewRecording];
        [self showSaveRecordingActionSheet];
    }
    else {
        
    }
}

@end

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
    background.image = bustedUpChael;
    [background.layer setOpacity:0.2];
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
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
    else if ([[segue identifier] isEqualToString:@"info"]) {
        // 4/16/2012 david set delegate when you push the info button
        
        FlipsideViewController *fvc = segue.destinationViewController;
        fvc.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"tweets"]) {

    }
    else if ([[segue identifier] isEqualToString:@"tabbar"]) {
        ActionsViewController *avc = segue.destinationViewController;
        avc.selectedIndex   = actionsViewController.selectedIndex;
        avc.actionsDelegate = self;
    }
    else {        
        DebugLog(@"did segue with unknown identifier: %@", [segue identifier]);
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

#pragma mark - <UIActionSheetDelegate>

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DebugLog(@"Clicked button #%d", buttonIndex);
    
    if(buttonIndex == 0) {
        // save it in core data!

        id context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
        
        for (PlayedSound *s in playedSounds) {
            
            // persists all the playedsounds
            
            [NSManagedObject insertPlayedSoundWithName:s.soundName orWithSoundData:s.soundData inManagedObjectContext:context];
        }
        
        // persist a barrage!
        
        NSString *newBarrageTitle = @"New Barrage!";   // TODO- let user customize        
        [NSManagedObject insertBarrageWithTtitle:newBarrageTitle andSounds:playedSounds inManagedObjectContext:context];        
        NSError *err = nil;
         
         if(![context save:&err]) {
             DebugLog(@"Error persisting recording: %@", err);
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
        
        [self showSaveRecordingActionSheet];
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
    for (int i=0; i < [playedSounds count]; i++) {
        
        PlayedSound *curr = [playedSounds objectAtIndex:i];
        NSString *soundName = curr.soundName;
        
        //NSLog(@"SonnensMouthViewController.m:175   i:%d    Date: %@.  Time: %@.   Sound: %@", i, [dateFormat stringFromDate:when], [timeFormat stringFromDate:when], soundName);
        
        NSTimeInterval sleepDuration = 0.0;
        
        if(i == 0) {
            // play sound after (when - recordStart) seconds
            
            sleepDuration = [curr.date timeIntervalSinceNow] - [recordStart timeIntervalSinceNow];
        }
        else {
            // play sound after (when - prevWhen) seconds
            PlayedSound *prevSound = [playedSounds objectAtIndex:i-1];
            NSDate *prevWhen = prevSound.date;
            
            if(prevWhen) {
                sleepDuration = [curr.date timeIntervalSinceNow] - [prevWhen timeIntervalSinceNow];
            }
        }
        
        //NSLog(@"SonnensMouthViewController.m:197  playRecording()   sleeping for %f seconds", sleepDuration);
        
        [NSThread sleepForTimeInterval:sleepDuration];
        
        [[SonnensMouth sonnensMouth] playSound:soundName];
    }

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
        
    soundButton.titleLabel.font = [soundButton.titleLabel.font fontWithSize:20.0];

    // this dosent work to maintain the same font color for some reason =
    soundButton.titleLabel.textColor = soundButton.titleLabel.textColor;
    
    CGFloat newRightBound = [self calculateRightBound:soundButton];

    // Calculate x-axis adjustment so that it dosen't get cut off to the right or left
    CGFloat adjustment = 0.0;
    CGFloat additionalRightAdjustment = 60.0;
    
    if (newRightBound > 320.0) {
        adjustment = newRightBound - 320.0 + additionalRightAdjustment;
    }
    
    CGRect widerFrame = CGRectMake(originalButtonFrame.origin.x-adjustment, originalButtonFrame.origin.y, originalButtonFrame.size.width*2, originalButtonFrame.size.height);
    
    soundButton.frame = widerFrame;
}

-(IBAction)makeButtonTextSmall:(id)sender
{
    UIButton *soundButton = (UIButton *)sender;
    soundButton.titleLabel.font = [soundButton.titleLabel.font fontWithSize:14.0];
//    [soundButton sizeToFit];
    
    soundButton.frame = originalButtonFrame;

}

-(IBAction)playSound:(id)sender
{
    PlaySoundUIButton *b = (PlaySoundUIButton *)sender;
    [[SonnensMouth sonnensMouth] playSound:b.soundName];
    
    if (isRecording) {  
        id context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];        
        PlayedSound *newPlayedSound = [NSManagedObject insertPlayedSoundWithName:b.soundName orWithSoundData:nil inManagedObjectContext:context];         
        [playedSounds addObject:newPlayedSound];

    }
}

@end

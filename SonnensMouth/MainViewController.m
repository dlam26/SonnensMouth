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

#pragma mark  IBAction's

// 4/3/12 - From a UISwitch
// 
-(IBAction)switchBackground:(id)sender
{
    DebugLog(@" switchin' the background...");    
    background.image = (background.image == smilingChael) ? bustedUpChael : smilingChael;
}


-(IBAction)playSound:(id)sender
{
    PlaySoundUIButton *b = (PlaySoundUIButton *)sender;
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:b.soundName ofType:@"m4a"];
    
    if(soundFilePath) {        
        DebugLog(@"   playing sound: \"%@\"", b.soundName);
        
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        NSError *err;
        
        if([fileURL checkResourceIsReachableAndReturnError:&err] == YES) {
            
            AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];    
            [newPlayer play];
        }
    }
    else {
        DebugLog(@"No sound named, %@", b.soundName);
    }
}


@end

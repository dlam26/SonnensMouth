//
//  AboutViewController.m
//  SonnensMouth
//
//  Created by david lam on 5/16/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

- (id)init {
    self = [super init];
    if (self) {
        recorder = [[AVAudioRecorder alloc] initWithURL:[SonnensMouth getRecordedNameURL] settings:nil error:nil];        
        [recorder setDelegate:self];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    appVersion.text = [NSString stringWithFormat:@"SonnensMouth %@", version];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - <MFMailComposeViewControllerDelegate>

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [mailCompose dismissModalViewControllerAnimated:YES];
}

#pragma mark - <AVAudioRecorderDelegate>

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    DebugLog();
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    DebugLog();
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    DebugLog();
}

#pragma mark - IBAction's

-(IBAction)sendFeedback:(id)sender
{
    DebugLog();
    
    if([MFMailComposeViewController canSendMail]) {        
        mailCompose = [[MFMailComposeViewController alloc] init];
        [mailCompose setMailComposeDelegate:self];
        [mailCompose setToRecipients:[NSArray arrayWithObject:@"apps@dlam.me"]];
        [mailCompose setSubject:@"Sonnen Show Feedback / Feature Request"];
        [self presentModalViewController:mailCompose animated:YES];
    }
    else {
        // Can't send email, so don't do anything!
    }
}

// TODO
-(IBAction)recordName:(id)sender
{
//    recordNameButton.enabled = NO;
//    playNameButton.enabled = NO;
    
    // e.g. record for just long enough to say your name
    BOOL recordWasSuccessful = [recorder recordForDuration:1.75];  
    
    DebugLog(@"recordWasSuccessful: %d", recordWasSuccessful);
}

// TODO
-(IBAction)playName:(id)sender
{
    DebugLog();
    
//    recordNameButton.enabled = NO;
//    playNameButton.enabled = NO;
    
    NSError *err;
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[SonnensMouth getRecordedNameURL] error:&err];    
    [player play];
}

@end

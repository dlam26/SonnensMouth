//
//  AboutViewController.m
//  SonnensMouth
//
//  Created by david lam on 5/16/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController


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
    id appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    appVersion.text = [NSString stringWithFormat:@"%@ %@", appName, version];
    
    recordingLabel.hidden = YES;
    recordNameButton.hidden = YES;
    playNameButton.hidden = YES;
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
    recordingLabel.hidden = YES;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    DebugLog();
    recordingLabel.hidden = YES;
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
/*
 
    http://stackoverflow.com/questions/4259078/osstatus-error-1718449215
 */ 
-(IBAction)recordName:(id)sender
{
//    recordNameButton.enabled = NO;
//    playNameButton.enabled = NO;
    
    recordingLabel.hidden = NO;
    
    NSError *recorderError;
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings setValue:[NSNumber numberWithInt:kAudioFormatAppleLossless] forKey:AVFormatIDKey];
//    [settings setValue:[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    [settings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [settings setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    [settings setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    

    
    recorder = [[AVAudioRecorder alloc] initWithURL:[SonnensMouth getRecordedNameURL] settings:settings error:&recorderError];
    [recorder setDelegate:self];
    
    
    // e.g. record for just long enough to say your name
    BOOL prepareWasSuccessful = [recorder prepareToRecord];
    BOOL recordWasSuccessful = [recorder recordForDuration:1.75];  
    
    DebugLog(@"prepareWasSuccessful: %d   recordWasSuccessful: %d   recorderError: %@", prepareWasSuccessful, recordWasSuccessful, [recorderError description]);
}

// TODO
-(IBAction)playName:(id)sender
{

    
//    recordNameButton.enabled = NO;
//    playNameButton.enabled = NO;
    
    NSError *err;
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[SonnensMouth getRecordedNameURL] error:&err];    
    [player play];
    
    DebugLog(@"  err: %@", err);
}

@end

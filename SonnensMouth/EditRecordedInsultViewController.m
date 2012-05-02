//
//  EditRecordedInsultViewController.m
//  SonnensMouth
//
//  Created by david lam on 4/25/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "EditRecordedInsultViewController.h"

@implementation EditRecordedInsultViewController

@synthesize barrage;

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
    
    self.title = @"Edit";
    
    [deleteButton setBackgroundImage:[[UIImage imageNamed:@"delete_button.png"]
                         stretchableImageWithLeftCapWidth:8.0f
                                             topCapHeight:0.0f]
                                                 forState:UIControlStateNormal];    
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setTitle:@"Delete Recording" forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    titleTextField.text   = [barrage title];
    titleTextField.delegate = self;
    createdDateLabel.text = [barrage createdAsString];
    updatedDateLabel.text = [barrage updatedAsString];
    lengthLabel.text      = [barrage durationAsString];
    soundsCountLabel.text = [NSString stringWithFormat:@"%u", [[barrage sounds] count]];
    
    // Make a hidden red 'Stop' button in the nav bar 
    
    stopPlayingRecordingButton = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStyleBordered target:self action:@selector(stopPlayingRecording:)];
    stopPlayingRecordingButton.tintColor = [UIColor redColor];
    
    // hide keyboard when tapping off a focused text field
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideInputs)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
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

-(void)hideInputs
{
    [titleTextField resignFirstResponder];
}

#pragma mark - IBAction's

-(IBAction)saveDetails:(id)sender
{
    DebugLog();    
    [barrage setTitle:titleTextField.text];
    [barrage setUpdated:[NSDate date]];
    updatedDateLabel.text = [barrage updatedAsString];
             
    NSError *err = nil;     
    if(![[barrage managedObjectContext] save:&err]) {
        DebugLog(@"Error persisting barrage: %@", err);
    }
     
//    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)email:(id)sender
{
    if([MFMailComposeViewController canSendMail]) {        
        mailCompose = [[MFMailComposeViewController alloc] init];
        [mailCompose setMailComposeDelegate:self];
        [mailCompose setSubject:@"Listen to this..."];
        [mailCompose setMessageBody:@"It's made up of Chael Sonnen sound clips :P" isHTML:YES];

        NSData *data       = [barrage toData];        
        NSString *fileName = [NSString stringWithFormat:@"%@.m4a", [barrage title]];
        
        [mailCompose addAttachmentData:data mimeType:@"video/mp4" fileName:fileName];

//        [mailCompose addAttachmentData:data mimeType:@"audio/mpeg3" fileName:@"sonnen-sound.mp3"];  // no work
     
        [self presentModalViewController:mailCompose animated:YES];
    }
    else {
        // Can't send email, so don't do anything!
    }
}

-(IBAction)play:(id)sender
{
    self.navigationItem.rightBarButtonItem = stopPlayingRecordingButton;
    
    [[SonnensMouth sonnensMouth] playBarrage:barrage];
}

-(IBAction)deleteRecording:(id)sender
{ 
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Really delete?" message:@"This will delete the recording permanently!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alertView show];
}

// Copied and pasted from RecordedInsultsViewController.m:108
- (IBAction)stopPlayingRecording:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
    [SonnensMouth sonnensMouth].cancelPlaySound = YES;
}


#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // buttonIndex 0 is the cancel button
    // buttonIndex 1 is the delete button
    //
    if(buttonIndex == 1) {
        [self.barrage.managedObjectContext deleteObject:barrage];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == titleTextField) {
        [self saveDetails:textField];
        [textField resignFirstResponder];
    }       
    
    return YES;
}


#pragma mark - <MFMailComposeViewControllerDelegate>

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    DebugLog(@"   error: %@", error);
    
    [mailCompose dismissModalViewControllerAnimated:YES];
}


@end

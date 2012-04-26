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
    
    [deleteButton setBackgroundImage:[[UIImage imageNamed:@"delete_button.png"]
                         stretchableImageWithLeftCapWidth:8.0f
                                             topCapHeight:0.0f]
                                                 forState:UIControlStateNormal];    
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    deleteButton.titleLabel.shadowColor = [UIColor lightGrayColor];
    deleteButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    deleteButton.titleLabel.text = @"Delete Recording";
    deleteButton.titleLabel.textColor = [UIColor whiteColor];
    
    titleTextField.text   = [barrage getTitle];
    createdDateLabel.text = [barrage createdAsString];
    
    
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

-(IBAction)save:(id)sender
{
    DebugLog();    
    [barrage setTitle:titleTextField.text];
    [barrage setUpdated:[NSDate date]];
         
    NSError *err = nil;
     
    if(![[barrage managedObjectContext] save:&err]) {
        DebugLog(@"Error persisting barrage: %@", err);
    }
     
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)play:(id)sender
{
    [[SonnensMouth sonnensMouth] playBarrage:barrage];
}

-(IBAction)deleteRecording:(id)sender
{
    DebugLog();
}

@end

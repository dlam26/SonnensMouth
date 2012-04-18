//
//  ActionsViewController.m
//  SonnensMouth
//
//  Created by david lam on 4/18/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "ActionsViewController.h"

@implementation ActionsViewController

@synthesize actionsDelegate = _actionsDelegate;

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations

    return YES;
    
    /*
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
     */
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    newOrientation = toInterfaceOrientation;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{   
    BOOL onSonnenSaidSoTab = self.selectedIndex == 0;
    
    if(onSonnenSaidSoTab) {
        
        SaidSoViewController *s = (SaidSoViewController *)self.selectedViewController;
        [s fit];
    }
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.actionsDelegate actionsViewControllerDidFinish:self];
}




@end

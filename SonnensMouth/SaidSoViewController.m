//
//  SaidSoViewController.m
//  SonnensMouth
//
//  Pushes a UIWebView that just shows http://chaelsonnensaidso.com/
//
//
//  Created by david lam on 4/17/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "SaidSoViewController.h"

@implementation SaidSoViewController

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
    DebugLog();
    
    [super viewDidLoad];
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


- (IBAction)done:(id)sender
{
    ActionsViewController *avc = (ActionsViewController *)[self tabBarController];
    
    [[avc actionsDelegate] actionsViewControllerDidFinish:avc];
}



@end

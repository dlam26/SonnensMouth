//
//  DirectoryListViewControllerViewController.m
//  SonnensMouth
//
//  Created by David Lam on 4/22/12.
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "DirectoryListViewController.h"

@interface DirectoryListViewController ()

@end

@implementation DirectoryListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideInputs)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)hideInputs
{
    [directoryInput resignFirstResponder];
}

-(IBAction)viewDirectory:(id)sender
{
    NSError *err;
    
    NSArray *dir = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryInput.text error:&err];
    
    DebugLog(@"Contents of %@:\n\n%@", directoryInput.text, dir);
    
    
}

-(IBAction)putInPath:(id)sender
{
    directoryInput.text = @"/private/var/mobile/Applications/F9479585-F1CD-4C17-A65E-A9B212A88B2C/tmp/";
}

-(IBAction)putInDocumentDirectory:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    directoryInput.text = [paths objectAtIndex:0];
}

-(IBAction)putInTempDirectory:(id)sender
{
    directoryInput.text = NSTemporaryDirectory();
}

-(IBAction)playSonnenSound:(id)sender
{
    [[SonnensMouth sonnensMouth] playSound:@"sonnen-sound"];
}

-(IBAction)dataLength:(id)sender
{
    NSString *path = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"sonnen-sound.m4a"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    
    DebugLog(@"data length: %u", [data length]);
}

@end

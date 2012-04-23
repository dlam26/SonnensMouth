//
//  DirectoryListViewControllerViewController.h
//  SonnensMouth
//
//  Created by David Lam on 4/22/12.
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SonnensMouth.h"

@interface DirectoryListViewControllerViewController : UIViewController
{
    IBOutlet UITextField *directoryInput;
    IBOutlet UIButton *viewButton;
}

-(IBAction)viewDirectory:(id)sender;
-(IBAction)putInPath:(id)sender;
-(IBAction)putInDocumentDirectory:(id)sender;

@end
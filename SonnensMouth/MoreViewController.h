//
//  MoreViewController.h
//  SonnensMouth
//
//  Created by David Lam on 4/23/12.
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SonnensMouth.h"
#import "DirectoryListViewController.h"
#import "ActionsViewController.h"

#define VOICE_OF_REASON_ROW 0 
#define FIGHT_RECORD_ROW 1
//#define DIRECTORY_LIST_ROW 2
#define ABOUT_LIST_ROW 2

@interface MoreViewController : UITableViewController <UIWebViewDelegate> {
    
    UIWebView *webView;
    UIViewController *webViewController;
}

- (IBAction)done:(id)sender;

-(void)showAboutView;
-(void)showBookWebView;
-(void)showFightRecordWebView;

-(void)showWebViewAt:(NSString *)address withTitle:(NSString *)title;

-(void)openInSafari;

@end

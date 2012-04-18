//
//  SaidSoViewController.h
//  SonnensMouth
//
//  Created by david lam on 4/17/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SonnensMouth.h"
#import "ActionsViewController.h"

@class SaidSoViewController;


@interface SaidSoViewController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate> {
    
    IBOutlet UIWebView *sonnenSaidSoWebView;    
    int webViewLoads;
    CGFloat accumulatedZoomScale;
}

@property(nonatomic,retain) IBOutlet UIWebView *sonnenSaidSoWebView;


- (IBAction)done:(id)sender;
- (IBAction)nextQuote:(id)sender;

- (void)fit;


@end

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

@synthesize sonnenSaidSoWebView;

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
    sonnenSaidSoWebView.delegate = self;
    sonnenSaidSoWebView.scalesPageToFit = YES;
    sonnenSaidSoWebView.scrollView.delegate = self;
    webViewLoads = 0;
    
    NSURL *url = [NSURL URLWithString:@"http://chaelsonnensaidso.com/"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [sonnenSaidSoWebView loadRequest:req];
    
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (IBAction)done:(id)sender
{
    ActionsViewController *avc = (ActionsViewController *)[self tabBarController];
    
    [[avc actionsDelegate] actionsViewControllerDidFinish:avc];
}

- (IBAction)nextQuote:(id)sender
{
    // result here is 'false'
    NSString *result = [sonnenSaidSoWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('refreshpage').getElementsByTagName('a')[0].onclick()"];

    DebugLog(@"result: %@", result);    
}

#pragma mark - <UIWebViewDelegate>


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    webViewLoads++;
    
    if(webViewLoads == 1)
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // http://stackoverflow.com/questions/908367/uiwebview-how-to-identify-the-last-webviewdidfinishload-message
    
    webViewLoads--;
    
    if(webViewLoads > 0)
        return;
    
    [self fit];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DebugLog();
    
    webViewLoads--;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


#pragma mark - <UIScrollViewDelegate> 

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    DebugLog(@"  atScale: %f", scale);
}



#pragma mark - My methods

// FIXME:  need to zoom out or else the zoomScale keeps adding on
- (void)fit
{
    CGFloat newZoomScale;
    CGFloat newY;
        
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {                
        newZoomScale = 1.6;
        newY = 20.0;
    }
    else if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        newZoomScale = 1.0;
        newY = 120.0;
    }
    else {
        DebugLog(@"SHOULDNT GET HERE!");
        newZoomScale = 0;
        newY = 0;
    }
    
    accumulatedZoomScale += newZoomScale;
        
//    DebugLog(@"currZoomScale: %f   newZoomScale: %f   newY: %f   accumulatedZoomScale: %f", currZoomScale, newZoomScale, newY, accumulatedZoomScale);
    
    [[sonnenSaidSoWebView scrollView] setZoomScale:newZoomScale animated:YES];    
    [[sonnenSaidSoWebView scrollView] setContentOffset:CGPointMake(sonnenSaidSoWebView.scrollView.contentOffset.x, newY) animated:YES];        
    
}




@end

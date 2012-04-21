//
//  RecordedInsultsViewController.m
//  SonnensMouth
//
//  Created by david lam on 4/20/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "RecordedInsultsViewController.h"

@implementation RecordedInsultsViewController

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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction's

/*
    http://stackoverflow.com/questions/4191569/how-to-append-two-audio-files
 
 */
- (IBAction)test:(id)sender
{
    DebugLog();
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *track  = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [NSURL fileURLWithPath:@""];
    
    NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"i-am-a-gangster-from-america" ofType:@"m4a"]];
    NSURL *url2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"you-are-an-immigrant-from-brazil" ofType:@"m4a"]];
     
    AVURLAsset *aa1 = [[AVURLAsset alloc] initWithURL:url1 options:nil];
    AVURLAsset *aa2 = [[AVURLAsset alloc] initWithURL:url2 options:nil];
    NSError *error;
    
    [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, aa1.duration) ofTrack:[[aa1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:&error];
        
    [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, aa2.duration) ofTrack:[[aa2 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:aa1.duration error:&error];
    
    // Create a directory to put a file in    
//    NSString *dir = @"/davidsounds";
    NSString *dir = @"/";
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *fileManagerError;
//    [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&fileManagerError];
//    
//    if(fileManagerError)
//        DebugLog(@"Got fileManagerError: %@", fileManagerError);

    AVAssetExportSession *export = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    
//    [export setOutputURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@aaa", dir]]];

    NSURL *newFileUrlPath = [[NSURL alloc] initFileURLWithPath:@"/davidsounds/aaa.m4a"];
    
    [export setOutputURL:newFileUrlPath];
    [export setOutputFileType:AVFileTypeAppleM4A];
     
    [export exportAsynchronouslyWithCompletionHandler:^{
        
        switch (export.status) {
            case AVAssetExportSessionStatusFailed:
                DebugLog(@"Failed!  error: %@", export.error);
                break;                
            case AVAssetExportSessionStatusCompleted:
                DebugLog(@"Completed!");
                break;
            default:
                break;
        }
        
        DebugLog(@"omg  export.status: %d", export.status);
        
        NSArray *rootDirectoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/" error:nil];
        
        NSArray *davidSoundsDirectoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/davidsounds/" error:nil];
        
        DebugLog(@"contents of /: %@", rootDirectoryContents);
        DebugLog(@"Contents of davidsounds: %@", davidSoundsDirectoryContents);

    }];
}

- (IBAction)playGeneratedFile:(id)sender
{
    [SonnensMouth playSound:@"aaa"];
}

@end

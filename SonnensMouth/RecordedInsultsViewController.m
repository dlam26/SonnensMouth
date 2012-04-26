//
//  RecordedInsultsViewController.m
//  SonnensMouth
//
//  Created by david lam on 4/20/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "RecordedInsultsViewController.h"
#import "NSManagedObject+Barrage.h"

@implementation RecordedInsultsViewController

@synthesize recordings;

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

- (void)viewWillAppear:(BOOL)animated
{
    recordings.dataSource = self;
    recordings.delegate = self;
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Barrage"];
    NSSortDescriptor *updatedSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updated" ascending:NO];
    NSSortDescriptor *titleSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObjects:updatedSortDescriptor, titleSortDescriptor, nil];
    //    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"soundName = %@", @"blahh"];    
    NSString *cacheName = @"RecordedInsultsCache";
    
    fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:cacheName];    
    //    fetchedResultController.delegate = self;    
    
    NSError *fetchError;
    [fetchedResultController performFetch:&fetchError];
    
    if (fetchError) {
        DebugLog(@"Got fetchError: %@", fetchError);
    }
    
    [recordings reloadData];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Recordings";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
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

#pragma mark - IBAction's

/*
    http://stackoverflow.com/questions/4191569/how-to-append-two-audio-files
 
 */
- (IBAction)test:(id)sender
{
    DebugLog();
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *track  = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"grease-saint-pierre" ofType:@"m4a"]];
    NSURL *url2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"joo-jeet-su" ofType:@"m4a"]];
     
    AVURLAsset *aa1 = [[AVURLAsset alloc] initWithURL:url1 options:nil];
    AVURLAsset *aa2 = [[AVURLAsset alloc] initWithURL:url2 options:nil];
    NSError *error;
    
    [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, aa1.duration) ofTrack:[[aa1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:&error];
    
    // Delay 2 seconds :o
    [track insertEmptyTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(2.0, 1.0))];
    
    [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, aa2.duration) ofTrack:[[aa2 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:aa1.duration error:&error];
    
    // Create a directory to put a file in    
//    NSString *dir = @"/davidsounds";
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *fileManagerError;
//    [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&fileManagerError];
//    
//    if(fileManagerError)
//        DebugLog(@"Got fileManagerError: %@", fileManagerError);

    /*  
       4/22/12  Above dosent seem to work...
     
     2012-04-22 22:09:27.287 SonnensMouth[7743:707] RecordedInsultsViewController.m:95  -[RecordedInsultsViewController test:] Got fileManagerError: Error Domain=NSCocoaErrorDomain Code=513 "The operation couldn’t be completed. (Cocoa error 513.)" UserInfo=0xd6ac480 {NSFilePath=/davidsounds, NSUnderlyingError=0xd6abec0 "The operation couldn’t be completed. Operation not permitted"}
     2012-04-22 22:09:27.332 SonnensMouth[7743:707] RecordedInsultsViewController.m:110  __38-[RecordedInsultsViewController test:]_block_invoke_0 Failed!  error: Error Domain=AVFoundationErrorDomain Code=-11800 "The operation could not be completed" UserInfo=0xd6b0300 {NSLocalizedFailureReason=An unknown error occurred (-12124), NSUnderlyingError=0x2b3270 "The operation couldn’t be completed. (OSStatus error -12124.)", NSLocalizedDescription=The operation could not be completed}
     */
    
    
    AVAssetExportSession *export = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];

    //  NSTemporaryDirectory() returns something like this on device:
    //      /private/var/mobile/Applications/F9479585-F1CD-4C17-A65E-A9B212A88B2C/tmp/
    //
    NSString *td = NSTemporaryDirectory();
    NSURL *url = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"/%@/aaa.m4a", td]];
    
    [export setOutputURL:url];
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
        
//        NSArray *rootDirectoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/" error:nil];        
//        NSArray *davidSoundsDirectoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/davidsounds/" error:nil];
//        DebugLog(@"contents of /: %@", rootDirectoryContents);
//        DebugLog(@"Contents of davidsounds: %@", davidSoundsDirectoryContents);

    }];
}

- (IBAction)playGeneratedFile:(id)sender
{
    [[SonnensMouth sonnensMouth ]playSound:@"aaa"];
}

- (IBAction)done:(id)sender
{
    ActionsViewController *avc = (ActionsViewController *)[self tabBarController];    
    [[avc actionsDelegate] actionsViewControllerDidFinish:avc];
}



#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return [[fetchedResultController sections] count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [[[fetchedResultController sections] objectAtIndex:section] numberOfObjects];
    
    NSInteger count = [[fetchedResultController fetchedObjects] count];    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecordingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    Barrage *b = [fetchedResultController objectAtIndexPath:indexPath];            
    cell.textLabel.text = b.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Updated %@   |   Sounds: %u", [b updatedAsString], [[b sounds] count]];
    return cell;
}


#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"Clicked on accessory at row #%d", indexPath.row);
    
    selectedBarage = [fetchedResultController objectAtIndexPath:indexPath];
    
    EditRecordedInsultViewController *e = [self.storyboard instantiateViewControllerWithIdentifier:IDENTIFIER_EDIT_RECORDING_VIEW_CONTROLLER];
    e.barrage = selectedBarage;
    
    [[self navigationController] pushViewController:e animated:YES];    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"Clicked row #%d", indexPath.row);
    
    Barrage *b = [fetchedResultController objectAtIndexPath:indexPath];    
    [[SonnensMouth sonnensMouth] playBarrage:b];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:IDENTIFIER_SEGUE_EDIT_RECORDED_INSULT])
    {
        // Get reference to the destination view controller
        EditRecordedInsultViewController *vc = (EditRecordedInsultViewController *)[segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setBarrage:selectedBarage];
    }
    */
}



@end

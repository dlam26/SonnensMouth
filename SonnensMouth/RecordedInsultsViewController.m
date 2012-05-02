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
    
    savedRecordingsCount = [[fetchedResultController fetchedObjects] count];
    
    [recordings reloadData];
    
    // hide the stop recording button until one is played
    self.navigationItem.rightBarButtonItem = nil;
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

- (IBAction)done:(id)sender
{
    ActionsViewController *avc = (ActionsViewController *)[self tabBarController];    
    [[avc actionsDelegate] actionsViewControllerDidFinish:avc];
}

// Copied and pasted to EditRecordedInsultViewController.m:141
- (IBAction)stopPlayingRecording:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
    [SonnensMouth sonnensMouth].cancelPlaySound = YES;
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
        
    if (savedRecordingsCount > 0) {
        return savedRecordingsCount;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecordingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(savedRecordingsCount == 0 && indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView  = nil;
        cell.accessoryType  = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"No recordings yet.";
        cell.detailTextLabel.text = nil;
    }
    else {
        Barrage *b = [fetchedResultController objectAtIndexPath:indexPath];            
        cell.textLabel.text = b.title;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Updated: %@\nDuration: %@     Sounds: %u", [b updatedAsString], [b durationAsString], [[b sounds] count]];
    }

    return cell;
}


#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
//    DebugLog(@"Clicked on accessory at row #%d", indexPath.row);
    
    selectedBarage = [fetchedResultController objectAtIndexPath:indexPath];
    
    EditRecordedInsultViewController *e = [self.storyboard instantiateViewControllerWithIdentifier:IDENTIFIER_EDIT_RECORDING_VIEW_CONTROLLER];
    e.barrage = selectedBarage;
    
    [[self navigationController] pushViewController:e animated:YES];    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DebugLog(@"Clicked row #%d", indexPath.row);
    
    if(savedRecordingsCount > 0) {
        Barrage *b = [fetchedResultController objectAtIndexPath:indexPath];    
        
        [[SonnensMouth sonnensMouth] playBarrage:b thenDoThisWhenItsDone:^(void) {        
            // Will enter here if the Stop/Cancel button wasn't pressed.
            
            //DebugLog(@"IN COMPLETIONG BLOCK!!!!");        
            self.navigationItem.rightBarButtonItem = nil; 
        }];
        
        self.navigationItem.rightBarButtonItem = stopPlayingRecordingButton;
        self.navigationItem.rightBarButtonItem.action = @selector(stopPlayingRecording:);
        self.navigationItem.rightBarButtonItem.target = self;        
    }
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

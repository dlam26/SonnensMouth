//
//  Barrage.m
//  SonnensMouth
//
//  Created by David Lam on 4/23/12.
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "Barrage.h"
#import "PlayedSound.h"

@implementation Barrage

@dynamic title;
@dynamic sounds;
@dynamic created;
@dynamic updated;

-(NSString *)createdAsString
{
    return [self __formatDate:self.created];
}

-(NSString *)updatedAsString
{
    return [self __formatDate:self.updated];
}

-(NSString *)__formatDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    return [formatter stringFromDate:date];
}

-(NSString *)getTitle
{
    return self.title;
}

-(NSArray *)soundsAsArray
{
    return [[self sounds] sortedArrayUsingDescriptors:[NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];        
}

/*
    Converts the sounds in this barrage to an NSData so you can play it via AudioToolbox
    or AVAudioPlayer or sumthin ^^ 
 */
-(NSData *)toData
{
    __block NSData *data;
    
    NSArray *soundsArray = [self soundsAsArray];
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *track  = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];    
    NSTimeInterval sleepDuration = 0.0;
    
    for (int i=0; i < [soundsArray count]; i++) {
        
        PlayedSound *curr = [soundsArray objectAtIndex:i];
        
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[curr soundName] ofType:@"m4a"]];
        
        // Calculate sleep duration        
        if(i == 0) {            
            sleepDuration = [curr.date timeIntervalSinceNow] - [self.created timeIntervalSinceNow];
        }
        else {
            PlayedSound *prevSound = [soundsArray objectAtIndex:i-1];
            NSDate *prevWhen       = prevSound.date;
            
            if(prevWhen) {
                sleepDuration = [curr.date timeIntervalSinceNow] - [prevWhen timeIntervalSinceNow];
            }
        }
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];        
        NSError *error;
        
        [track insertEmptyTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(sleepDuration, 1.0))];
        
        [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:asset.duration error:&error];
    }
    
    AVAssetExportSession *export = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];

    NSURL *url = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"/%@/sonnen-sound.m4a", NSTemporaryDirectory()]];
    
    [export setOutputURL:url];
    [export setOutputFileType:AVFileTypeAppleM4A];     
    
    __block BOOL workedOrNo = NO;
    
    [export exportAsynchronouslyWithCompletionHandler:^{        
        switch (export.status) {
                
            case AVAssetExportSessionStatusFailed:
                break;                
            case AVAssetExportSessionStatusCompleted:
                workedOrNo = YES;
                data = [[NSFileManager defaultManager] contentsAtPath:[url absoluteString]];
                break;
            default:
                break;
        }
    }];
    
    NSLog(@"Barrage.m:111  toData()  did export work?  %d", workedOrNo);
    
    return data;
}

@end

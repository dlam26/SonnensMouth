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

/*  
    Returns a string like "1:36" indicating the sound length in minutes and seconds
 */
-(NSString *)durationAsString
{
    NSString *durationString = @"0:00";
    NSTimeInterval duration, sleepDuration = 0.0;  //this is just a typedef to double, in seconds

    NSArray *soundsArray = [self soundsAsArray];
    
    for (int i = 0; i < [soundsArray count]; i++) {        
        
        PlayedSound *sound = [soundsArray objectAtIndex:i];
        NSString *soundFilePath = [sound getBundleFilePath];       
        NSData *soundData = [[NSFileManager defaultManager] contentsAtPath:soundFilePath];
        NSError *err = nil;
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:&err];

        if(!err) {
            duration += audioPlayer.duration;

#if DURATION_INCLUDE_SLEEP_TIME
            if(i > 0) {                
                PlayedSound *prevSound = [soundsArray objectAtIndex:i-1];
                NSDate *prevWhen       = prevSound.date;
                
                if(prevWhen) {
                    sleepDuration += [sound.date timeIntervalSinceNow] - [prevWhen timeIntervalSinceNow];
                }
            }
#endif
        }
        else {
            DebugLog(@"Couldn't calculate length, error opening sound: %@", sound.soundName);
            duration = -1;
            break;
        }
    }
        
    if(duration != -1) {
        
        duration = duration + sleepDuration;

        // http://stackoverflow.com/questions/2558995/how-can-i-define-nstimeinterval-to-mmss-format-in-iphone
        long minutes = (long) duration / 60;
        long seconds = (long) duration % 60;        
        durationString = [NSString stringWithFormat:@"%01d:%02d", minutes, seconds];
    }
    
    return durationString;
}


-(NSArray *)soundsAsArray
{
    return [[self sounds] sortedArrayUsingDescriptors:[NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];        
}

// http://stackoverflow.com/questions/586370/how-can-i-reverse-a-nsarray-in-objective-c
-(NSArray *)soundsAsArrayReversed
{
    NSMutableArray *soundsReversed = [[NSMutableArray alloc] init];
    NSMutableArray *sounds = [[NSMutableArray alloc] initWithArray:self.soundsAsArray];
    NSEnumerator *enumerator = [sounds reverseObjectEnumerator];
    
    for(id element in enumerator) {
        [soundsReversed addObject:element];
    }
    
    return soundsReversed;

}

/*
    Converts the sounds in this barrage to an NSData so you can play it via AudioToolbox
    or AVAudioPlayer or sumthin ^^ 
 */
-(NSData *)toData
{
    NSData *data;
    __block NSError *error;
    
    NSArray *soundsArray = [self soundsAsArrayReversed];
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *track  = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];    
    
    for (int i=0; i < [soundsArray count]; i++) {
        
        PlayedSound *curr = [soundsArray objectAtIndex:i];
        NSTimeInterval sleepDuration = 0.0;
        
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[curr soundName] ofType:@"m4a"]];
        
        NSTimeInterval secondTimeInterval = 0.0;
        
        // Calculate sleep duration        
        if(i == 0) {            
            secondTimeInterval = [self.created timeIntervalSinceNow];
        }
        else {
            PlayedSound *prevSound = [soundsArray objectAtIndex:i-1];
            NSDate *prevWhen       = prevSound.date;
            
            if(prevWhen) {
                secondTimeInterval = [prevWhen timeIntervalSinceNow];
            }
        }
        
        sleepDuration = [curr.date timeIntervalSinceNow] - secondTimeInterval;
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];        

          // 5/2/12 for some reason this can be negative, and the sleep seems too long
        sleepDuration = fabs(sleepDuration / 2.0); 
        
        DebugLog(@"i: %d   sleepDuration: %f   curr.date: %fc   secondTimeInterval: %f", i, sleepDuration, [curr.date timeIntervalSinceNow], secondTimeInterval );
        
        [track insertEmptyTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(sleepDuration, 1.0))];
        
        [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:asset.duration error:&error];
    }
    
    // seems to be 1.5 seconds of dead space at start of generated sound file no matter what
    // ...so remove it
    [track removeTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(1.5, 1.0))];
    
    AVAssetExportSession *export = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];

    NSURL *url = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@%@%@", NSTemporaryDirectory(), self.title, @".m4a"]];
    
    DebugLog(@"Saving NSData audio file to temporary directory: %@", url);
    
    [export setOutputURL:url];
    [export setOutputFileType:AVFileTypeAppleM4A];
    
    
    __block BOOL workedOrNo = NO;
    
    [export exportAsynchronouslyWithCompletionHandler:^{

//        NSLog(@"export.status: %d", export.status);
        
        switch (export.status) {
            
            case AVAssetExportSessionStatusFailed:
                DebugLog(@"export.error: %@", export.error);
                break;                
            case AVAssetExportSessionStatusCompleted:
                workedOrNo = YES;
                break;
            default:
                break;
        }
        
    }];
    
    data = [[NSFileManager defaultManager] contentsAtPath:[url path]];
    
    return data;
}

@end

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

@synthesize emailDelegate;


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
//-(NSData *)toData
-(NSData *)toData:(id <EmailBarrageDelegate>)delegate
{
    __block NSData *data;
    __block NSError *error;
    
    NSArray *soundsArray = [self soundsAsArrayReversed];
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *track  = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];    
    
    for (int i=0; i < [soundsArray count]; i++) {
        
        PlayedSound *curr = [soundsArray objectAtIndex:i];
        PlayedSound *next;
        NSTimeInterval sleepDuration = 0.0;
        NSTimeInterval secondTimeInterval = 0.0;
        BOOL atLastSound = i == soundsArray.count-1;

        if(!atLastSound) {
            next = [soundsArray objectAtIndex:i+1];
        }
        
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
        sleepDuration = fabs(sleepDuration / 2.0);  // 5/2/12 for some reason this can be negative, and the sleep seems too long
        
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[curr soundName] ofType:@"m4a"]];
        AVURLAsset *playedSoundAsset = [[AVURLAsset alloc] initWithURL:url options:nil];

        CMTime playedsoundDuration = playedSoundAsset.duration;
        
        //
        // FIXME  5/20/12   Sound interruptions aren't handled by the code
        //                  ...below code was that start to an attempt to 
        //                  computer when a sound was interrupted so I could
        //                  calculate the proper duration to pass to 
        //                  AVMutableCompositionTrack insertTimeRange:
        //
        /*
        BOOL isInterrupted = NO;
        
        // check if the current sound was interrupted by the next
        if(next) {
            CMTime t = [playedSoundAsset duration];
            NSTimeInterval dur = t.value / t.timescale;
            NSDate *currSoundEnd = [curr.date dateByAddingTimeInterval:dur];

            isInterrupted = currSoundEnd > next.date;
            
            if (isInterrupted) {
                NSTimeInterval intervalz = [currSoundEnd timeIntervalSinceDate:next.date];                
                playedsoundDuration = CMTimeMake(intervalz, 1.0);
            }
        }
        
        DebugLog(@"i: %d   sleepDuration: %f   curr.date: %fc   secondTimeInterval: %f  isInterrupted: %d", i, sleepDuration, [curr.date timeIntervalSinceNow], secondTimeInterval, isInterrupted );
        */
        
        [track insertEmptyTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(sleepDuration, 1.0))];

        [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, playedsoundDuration) ofTrack:[[playedSoundAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:playedsoundDuration error:&error];
    }
    
    // seems to be 1.5 seconds of dead space at start of generated sound file no matter what
    // ...so remove it
    [track removeTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(1.5, 1.0))];
    
    AVAssetExportSession *export = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];

    // 5/21/12  export session failing with error if the file exists, so make a random number
    int randomNumber = arc4random() % 12345;
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@%@%d%@", NSTemporaryDirectory(), self.title, randomNumber, @".m4a"]];
    
    DebugLog(@"Saving NSData audio file to temporary directory: %@", url);
    
    
    [export setOutputURL:url];
    [export setOutputFileType:AVFileTypeAppleM4A];
        
    __block BOOL workedOrNo = NO;
    
    [export exportAsynchronouslyWithCompletionHandler:^{

        DebugLog(@"export.status: %d", export.status);
        
        switch (export.status) {
            
            case AVAssetExportSessionStatusFailed:
                DebugLog(@"export.error: %@", export.error);
                [delegate setIsDoneExporting:YES];
                break;                
            case AVAssetExportSessionStatusCompleted:
                DebugLog(@"AVAssetExportSessionStatusCompleted");
                workedOrNo = YES;
                
                data = [[NSFileManager defaultManager] contentsAtPath:[url path]];
                
                DebugLog(@"[url path]: %@    data length: %u", [url path], [data length]);
                
//                [delegate emailBarrage:data];
                
                [delegate setData:data];
                [delegate setIsDoneExporting:YES];
                
                break;
            case AVAssetExportSessionStatusExporting:
                DebugLog(@"AVAssetExportSessionStatusExporting");
            case AVAssetExportSessionStatusUnknown:
                DebugLog(@"AVAssetExportSessionStatusUnknown");
            case AVAssetExportSessionStatusCancelled:
                DebugLog(@"AVAssetExportSessionStatusCancelled");
                [delegate setIsDoneExporting:YES];
            case AVAssetExportSessionStatusWaiting:
                DebugLog(@"AVAssetExportSessionStatusWaiting");
            default:
                DebugLog(@"In default somehow!!!1  export.status: %d", export.status);
                break;
        }
        
    }];
    
    return data;
}


@end

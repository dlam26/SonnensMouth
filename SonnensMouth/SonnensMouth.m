//
//  SonnensMouth.m
//  SonnensMouth
//
//  Created by david lam on 4/4/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "SonnensMouth.h"

@implementation SonnensMouth

static SonnensMouth* _sonnensMouth = nil;

@synthesize audioPlayer;

+(SonnensMouth *)sonnensMouth
{
    @synchronized(self) {
        if (_sonnensMouth == nil) {
            _sonnensMouth = [[SonnensMouth alloc] init];
        }
    }
    
    return _sonnensMouth;
}

+(void)setSonnensMouth:(SonnensMouth *)sonnensMouth
{
    @synchronized(self) {
        _sonnensMouth = sonnensMouth;
    }
}

+(UIAlertView *)newNoInternetConnectionAlertView
{    
    return [SonnensMouth newNoInternetConnectionAlertView:@"Error loading, check if you have an internet connection."];
}

+(UIAlertView *)newNoInternetConnectionAlertView:(NSString *)errorMessage
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oh snap!" message:errorMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];    
    return alertView;
}


-(void)playSound:(NSString *)soundName 
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"m4a"];
    
    if(!soundFilePath) {
        
        // The sound was generated by the user... so find it!
        
        NSString *td = NSTemporaryDirectory();
        NSString *p       = [NSString stringWithFormat:@"%@%@.m4a", td, soundName];
        NSData *soundData = [[NSFileManager defaultManager] contentsAtPath:p];

        if(soundData) {
            
            DebugLog(@"Found soundData at path, %@  ...so playing it!", p);
            
            NSError *err = nil;
            audioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:&err];
            [audioPlayer setDelegate:self];
            [audioPlayer setNumberOfLoops:0];   // default
            [audioPlayer prepareToPlay];
            [audioPlayer play];
            
            if(err)
                DebugLog(@"GOT ERR: %@", err);
                        
        }
        else {
            DebugLog(@"No soundData, so couldn't play it at path: %@", p);
        }
    }
    else {
        
        // Then the sound was bundled with the app, so play it
        
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        NSError *err;
            
        if([fileURL checkResourceIsReachableAndReturnError:&err] == YES) {
            
            DebugLog(@"   Playing sound using AVAudioPlayer: \"%@\"", soundName);
            
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&err];
            
            if(err) {
                DebugLog(@"Error when playing with AVAudioPlayer: %@", err);
            }
            else {
                [audioPlayer setDelegate:self];
                [audioPlayer setNumberOfLoops:0];   // default
                [audioPlayer prepareToPlay];
                [audioPlayer play];
            }

           
//            DebugLog(@"   Playing sound using AudioToolbox: \"%@\"", soundName);
//            
//            NSURL *soundEffectURL = [[NSBundle mainBundle] URLForResource: soundName withExtension:@"m4a"];
//            CFURLRef soundURL = (__bridge CFURLRef) soundEffectURL;
//            SystemSoundID soundID;
//            AudioServicesCreateSystemSoundID(soundURL, &soundID);
//            AudioServicesPlaySystemSound(soundID);            
        }
        else {
            DebugLog(@"No sound named, %@", soundName);
        }
    }
}



#pragma mark - <AVAudioPlayerDelegate>

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    DebugLog(@"successufully: %u", flag);
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    DebugLog(@"error: %@", error);
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    DebugLog();
}

@end

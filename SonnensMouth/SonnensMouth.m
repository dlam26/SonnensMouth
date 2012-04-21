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

+(void)playSound:(NSString *)soundName 
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"m4a"];
    
    if(!soundFilePath) {
        // look for the sound in the filesystem
        
//        NSData *stuff = [[NSFileManager defaultManager] contentsAtPath:@"/davidsounds/aaa.m4a"];
//        NSError *err = nil;
        
    
        soundFilePath = @"/davidsounds/aaa.m4a";
        
        
        DebugLog(@"Sound '%@' not found, so seeing if I can find it via NSFileManager!", soundName);
    }
    else
        DebugLog(@"soundFilePath: %@", soundFilePath);
    
    if(soundFilePath) {        
        
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        NSError *err;
        
        if([fileURL checkResourceIsReachableAndReturnError:&err] == YES) {
            
            DebugLog(@"   playing sound: \"%@\"", soundName);
            
//            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];    
//            [player setDelegate:self];
//            [player play];
            
            
            NSURL *soundEffectURL = [[NSBundle mainBundle] URLForResource: soundName withExtension:@"m4a"];
            CFURLRef soundURL = (__bridge CFURLRef) soundEffectURL;
            SystemSoundID soundID;
            AudioServicesCreateSystemSoundID(soundURL, &soundID);
            AudioServicesPlaySystemSound(soundID);
            
            
        }
    }
    else {
        DebugLog(@"No sound named, %@", soundName);
    }
}

@end

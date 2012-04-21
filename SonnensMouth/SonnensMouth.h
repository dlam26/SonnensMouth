//
//  SonnensMouth.h
//  SonnensMouth
//
//   Singleton class.
//

#ifndef SonnensMouth_SonnensMouth_h
#define SonnensMouth_SonnensMouth_h

#ifdef DEBUG
#define DebugLog(__FORMAT__, ...) NSLog((@"%@:%d  %s " __FORMAT__), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define DebugLog(...) do {} while (0)
#endif

#define TWEETS_URL @"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=sonnench"

//  #import <Foundation/Foundation.h>

#import <CoreFoundation/CoreFoundation.h>


#import <AudioToolbox/AudioToolbox.h>

#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>


@interface SonnensMouth : NSObject {
 
    
}

+(SonnensMouth *)sonnensMouth;
+(void)setSonnensMouth:(SonnensMouth *)sonnensMouth;
+(void)playSound:(NSString *)soundName;

@end

#endif

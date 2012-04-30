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

#define USE_AV_AUDIO_PLAYER 1

#define TWEETS_API_URL @"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=sonnench"


// identifier in Interface Builder
#define IDENTIFIER_DIRECTORY_LIST @"Directory List"
#define IDENTIFIER_ABOUT @"About"

// Used in the segue/link when you edit a recorded insult
#define IDENTIFIER_EDIT_RECORDING_VIEW_CONTROLLER @"Edit Recording"

//  #import <Foundation/Foundation.h>

#import <CoreFoundation/CoreFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>

#import "PlayedSound.h"
#import "Barrage.h"

typedef void (^CompleteBlock)();

@class Barrage;

@interface SonnensMouth : NSObject <AVAudioPlayerDelegate> {
 
    AVAudioPlayer *audioPlayer;
    NSThread *playSoundThread;
    NSOperation *playSoundOperation;

    BOOL cancelPlaySound;
    BOOL playingLastSoundInBarrage;
    
    CompleteBlock playBarrageCompleteBlock;
}

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL cancelPlaySound;
@property (nonatomic) BOOL playingLastSoundInBarrage;




+(SonnensMouth *)sonnensMouth;
+(void)setSonnensMouth:(SonnensMouth *)sonnensMouth;
-(void)playSound:(NSString *)soundName;
-(void)playBarrage:(Barrage *)barrage;
-(void)playBarrage:(Barrage *)barrage thenDoThisWhenItsDone:(CompleteBlock)completeBlock;

-(void)playArrayOfSounds:(NSArray *)sounds withStart:(NSDate *)startingDate;


+(UIAlertView *)newNoInternetConnectionAlertView;
+(UIAlertView *)newNoInternetConnectionAlertView:(NSString *)errorMessage;

@end

#endif

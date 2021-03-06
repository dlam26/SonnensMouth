//
//  NSManagedObject+PlayedSound.m
//  SonnensMouth
//
//  Created by David Lam on 4/23/12.
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "NSManagedObject+PlayedSound.h"

@implementation NSManagedObject (PlayedSound)
    


+(PlayedSound * )insertPlayedSoundWithName:(NSString *)soundName 
             orWithSoundData:(NSData *)data
                    andOrder:(NSNumber *)order
      inManagedObjectContext:(NSManagedObjectContext *)context
{
    PlayedSound *newPlayedSound = (PlayedSound *) [NSEntityDescription insertNewObjectForEntityForName:@"PlayedSound" inManagedObjectContext:context];   

    if(soundName) {
        newPlayedSound.soundName = soundName;
    }
    else {
        newPlayedSound.soundData = data;
    }
    
    newPlayedSound.date  = [NSDate date];
    newPlayedSound.order = order;    
    
    return newPlayedSound;
}

@end

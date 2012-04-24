//
//  NSManagedObject+PlayedSound.h
//  SonnensMouth
//
//  Created by David Lam on 4/23/12.
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "PlayedSound.h"

@interface NSManagedObject (PlayedSound) {
    
}


+(PlayedSound * )insertPlayedSoundWithName:(NSString *)soundName 
             orWithSoundData:(NSData *)data
      inManagedObjectContext:(NSManagedObjectContext *)context;



@end

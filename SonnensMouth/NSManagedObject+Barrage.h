//
//  NSManagedObject+Barrage.h
//  SonnensMouth
//
//  Created by David Lam on 4/23/12.
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "Barrage.h"

@interface NSManagedObject (Barrage) {
    
}

+(Barrage *)insertBarrageWithTtitle:(NSString *)title
                           andSounds:(NSArray *)sounds
             inManagedObjectContext:(NSManagedObjectContext *)context;

@end

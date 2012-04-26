//
//  NSManagedObject+Barrage.m
//  SonnensMouth
//
//  Created by David Lam on 4/23/12.
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "NSManagedObject+Barrage.h"

@implementation NSManagedObject (Barrage)


+(Barrage *)insertBarrageWithTtitle:(NSString *)title
                          andSounds:(NSSet *)sounds
             inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    Barrage *newBarrage = (Barrage *)[NSEntityDescription insertNewObjectForEntityForName:@"Barrage" inManagedObjectContext:context];   
    newBarrage.title = title;
    newBarrage.sounds = sounds;
    newBarrage.created = [NSDate date];
    newBarrage.updated = [NSDate date];
    return newBarrage;
}

@end

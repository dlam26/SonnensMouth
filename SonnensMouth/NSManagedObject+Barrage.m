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
                          andSounds:(NSArray *)sounds
             inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    Barrage *newBarrage = [NSEntityDescription insertNewObjectForEntityForName:@"Barrage" inManagedObjectContext:context];   
    newBarrage.title = title;
    newBarrage.sounds = sounds;
    return newBarrage;
}

@end

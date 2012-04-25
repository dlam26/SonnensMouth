//
//  Barrage.h
//  SonnensMouth
//
//  Created by David Lam on 4/23/12.
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

// many-to-many relationship with PlayedSound s!    

//  https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CoreData/Articles/cdRelationships.html

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlayedSound;

@interface Barrage : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *sounds;     // of PlayedSound's

@end

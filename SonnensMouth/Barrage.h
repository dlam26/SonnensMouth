//
//  Barrage.h
//  SonnensMouth
//
//  Created by David Lam on 4/23/12.
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

// many-to-many relationship with PlayedSound s!    

//  https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CoreData/Articles/cdRelationships.html

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlayedSound;

@interface Barrage : NSManagedObject {
    
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSSet *sounds;     // of PlayedSound's
@property (nonatomic, retain) NSDate *created;
@property (nonatomic, retain) NSDate *updated;


-(NSString *)createdAsString;
-(NSString *)updatedAsString;
-(NSString *)__formatDate:(NSDate *)date;
-(NSString *)getTitle;
-(NSArray *)soundsAsArray;
-(NSData *)toData;

@end

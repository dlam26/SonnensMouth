//
//  PlayedSound.h
//  SonnensMouth
//
//  Created by David Lam on 4/23/12.
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlayedSound : NSManagedObject {
    
    
}

@property (nonatomic, retain) NSString * soundName;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSNumber *order;
@property (nonatomic, retain) NSData *soundData;
@property (nonatomic, retain) NSManagedObject *barrages;

@end

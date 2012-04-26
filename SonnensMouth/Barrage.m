//
//  Barrage.m
//  SonnensMouth
//
//  Created by David Lam on 4/23/12.
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "Barrage.h"
#import "PlayedSound.h"


@implementation Barrage

@dynamic title;
@dynamic sounds;
@dynamic created;
@dynamic updated;


-(NSString *)createdAsString
{
        return [self __formatDate:self.updated];
}

-(NSString *)updatedAsString
{
    return [self __formatDate:self.updated];
}

-(NSString *)__formatDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    return [formatter stringFromDate:date];
}

-(NSString *)getTitle
{
    return self.title;
}

@end

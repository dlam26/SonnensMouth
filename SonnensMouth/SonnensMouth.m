//
//  SonnensMouth.m
//  SonnensMouth
//
//  Created by david lam on 4/4/12   .
//  Copyright (c) 2012 dlam.me. All rights reserved.
//

#import "SonnensMouth.h"

@implementation SonnensMouth

static SonnensMouth* _sonnensMouth = nil;

+(SonnensMouth *)sonnensMouth
{
    @synchronized(self) {
        if (_sonnensMouth == nil) {
            _sonnensMouth = [[SonnensMouth alloc] init];
        }
    }
    
    return _sonnensMouth;
}

+(void)setSonnensMouth:(SonnensMouth *)sonnensMouth
{
    @synchronized(self) {
        _sonnensMouth = sonnensMouth;
    }
}

@end

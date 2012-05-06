//
//  PlaySoundUIButton.m
//  SonnensMouth
//
//  Created by david lam on 4/4/12   .
//  Copyright (c) 2012 das. All rights reserved.
//

#import "PlaySoundUIButton.h"

@implementation PlaySoundUIButton

@synthesize soundName;

-(void)awakeFromNib {
    [super awakeFromNib];   
    
    // debug by typing [UIFont familyNames in GDB to see what to put here: 
    
//    self.titleLabel.font = [UIFont fontWithName:@"Cheri Liney" size:14];  // cherl.ttf
    
//    self.titleLabel.font = [UIFont fontWithName:@"Denmark" size:14];  // denmark.ttf
    
    self.titleLabel.font = [UIFont fontWithName:@"PLATSCH" size:18];  // platsch.ttf
}


@end

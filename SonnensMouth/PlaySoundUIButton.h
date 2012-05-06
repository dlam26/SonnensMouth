//
//  PlaySoundUIButton.h
//  SonnensMouth
//
//  Created by david lam on 4/4/12   .
//  Copyright (c) 2012 das. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaySoundUIButton : UIButton {
    
    NSString *soundName;
}

@property(retain, nonatomic) NSString *soundName;


@end

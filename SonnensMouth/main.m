//
//  main.m
//  SonnensMouth
//
//  Created by david lam on 4/3/12   .
//  Copyright (c) 2012 das. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        
        //originally was just this:
        
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        
        //print stack trace for SIGABRT http://stackoverflow.com/questions/9122663/how-can-i-fix-this-sigabrt-error-with-my-app
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        } @catch (NSException *e) {
            NSLog(@"CRASH: %@", e);
            NSLog(@"Stack Trace: %@", [e callStackSymbols]);
        }
    }
}

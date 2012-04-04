//
//  SonnensMouth.h
//  SonnensMouth
//
//  Created by david lam on 4/3/12   .
//  Copyright (c) 2012 das. All rights reserved.
//

#ifndef SonnensMouth_SonnensMouth_h
#define SonnensMouth_SonnensMouth_h

#ifdef DEBUG
//#define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define DebugLog(__FORMAT__, ...) NSLog((@"%@:%d  %s " __FORMAT__), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define DebugLog(...) do {} while (0)
#endif




#endif

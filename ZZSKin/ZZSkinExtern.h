//
//  ZZSkinExtern.h
//  Demo
//
//  Created by 刘威振 on 8/29/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const ZZSkinChangingNotificaiton;
extern NSString * const ZZSkinCurrentTag;

// Lazy load micro define
#define LazyLoad_Common(ClassName, varName) \
- (ClassName *)varName { \
    if (_##varName == nil) { \
        _##varName = [[ClassName alloc] init]; \
    } \
    return _##varName; \
}
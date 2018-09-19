//
//  NSObject+ZZSkin.m
//  Demo
//
//  Created by liuxing8807@126.com on 8/29/16.
//  Copyright © 2016 liuweizhen. All rights reserved.
//

#import "NSObject+ZZSkin.h"
#import "ZZSkinManager.h"
#import <objc/runtime.h>
#import "ZZSkinExtern.h"

@interface NSObject ()

@property (nonatomic) ZZSkin *zz_skin;
@end

@implementation NSObject (ZZSkin)

#pragma mark - Nofitication

// Receive notification
- (void)zz_skinChangingNotificaiton:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.zz_skin change];
    });
}

#pragma mark - zz_skin
- (ZZSkin *)zz_skin {
    ZZSkin *skin = objc_getAssociatedObject(self, _cmd);
    if (!skin) {
        NSAssert(![self isKindOfClass:[ZZSkin class]], @"Class error: ZZSkin");
        skin         = [[ZZSkin alloc] init];
        self.zz_skin = skin;
        skin.master  = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zz_skinChangingNotificaiton:) name:ZZSkinChangingNotificaiton object:nil];
    }
    return skin;
}

- (void)setZz_skin:(ZZSkin *)zz_skin {
    objc_setAssociatedObject(self, @selector(zz_skin), zz_skin, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - zz_skinConfig

// 这样一个Block: 返回值是NSObject*， 参数是个block
- (block_skin_t)zz_skinConfig {
    block_skin_t skinConfig = objc_getAssociatedObject(self, _cmd);
    if (skinConfig == nil) {
        __weak typeof(self) weakSelf = self;
        skinConfig = ^NSObject *(block_id_t aBlockConfig) {
            NSString *currentTag = [[ZZSkinManager sharedManager] currentTag];
            if (currentTag) {
                if (aBlockConfig) {
                    aBlockConfig(weakSelf);
                    [weakSelf.zz_skin addSkinConfig:aBlockConfig];
                }
            }
            return weakSelf;
        };
        objc_setAssociatedObject(weakSelf, @selector(zz_skinConfig), skinConfig, OBJC_ASSOCIATION_COPY);
    }
    
    return skinConfig;
}

#pragma mark - dealloc

// dealloc -> zz_dealloc
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *selStringsArray = @[@"dealloc"];
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            NSString *zzSelString = [@"zz_" stringByAppendingString:selString];
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            Method zzMethod = class_getInstanceMethod(self, NSSelectorFromString(zzSelString));
            method_exchangeImplementations(originalMethod, zzMethod);
        }];
    });
}

- (void)zz_dealloc {
    if (objc_getAssociatedObject(self, @selector(zz_skin)) != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ZZSkinChangingNotificaiton object:nil];
        objc_removeAssociatedObjects(self);
    }
    [self zz_dealloc];
}

@end

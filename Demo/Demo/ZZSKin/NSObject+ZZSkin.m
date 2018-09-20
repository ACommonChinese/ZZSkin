//
//  NSObject+ZZSkin.m
//  Demo
//
//  Created by liuxing8807@126.com on 8/29/16.
//  Copyright © 2016 liuweizhen. All rights reserved.
//

#import "NSObject+ZZSkin.h"
#import "ZZSkinManager.h"

@implementation NSObject (ZZSkin)

#pragma mark - zz_skinConfig

- (block_skin_t)zz_skinConfig {
    __weak typeof(self) weakSelf = self;
    return ^NSObject *(block_id_t aBlockConfig) {
        NSString *currentTag = [[ZZSkinManager sharedManager] currentTag];
        if (currentTag) {
            if (aBlockConfig) {
                [[ZZSkinManager sharedManager] addObject:self configBlock:aBlockConfig];
                aBlockConfig(weakSelf);
            }
        }
        return weakSelf;
    };
}

- (void)zz_refresh {
    [[ZZSkinManager sharedManager] refresh:self];
}

@end

//
//  ZZSkin.m
//  Demo
//
//  Created by liuxing8807@126.com on 8/29/16.
//  Copyright © 2016 liuweizhen. All rights reserved.
//

#import "ZZSkin.h"
#import "ZZSkinExtern.h"
#import <UIKit/UIKit.h>

@interface ZZSkin()

@property (nonatomic) NSMutableArray *configArray;
@end

@implementation ZZSkin

- (void)addSkinConfig:(block_id_t)skinConfig {
    [self.configArray addObject:skinConfig];
}

- (void)change {
    for (block_id_t configBlock in self.configArray) {
        configBlock(self.master);
    }
    
    /**
    [UIView animateWithDuration:.25 animations:^{
        for (block_id_t configBlock in self.configArray) {
            configBlock(self.master);
        }
    }];
     */
}

LazyLoad_Common(NSMutableArray, configArray)

@end

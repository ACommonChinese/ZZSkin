//
//  ZZSkin.h
//  Demo
//
//  Created by liuxing8807@126.com on 8/29/16.
//  Copyright © 2016 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ZZSkin.h"

@interface ZZSkin : NSObject

@property (nonatomic, weak) id master;

- (void)addSkinConfig:(block_id_t)skinConfig;

- (void)change;

@end

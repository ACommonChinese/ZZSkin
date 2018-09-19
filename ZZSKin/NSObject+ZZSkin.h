//
//  NSObject+ZZSkin.h
//  Demo
//
//  Created by liuxing8807@126.com on 8/29/16.
//  Copyright © 2016 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^block_id_t)(id item);

// 返回值是NSObject *，参数是一个block
typedef NSObject * (^block_skin_t)(block_id_t blockConfig);

@interface NSObject (ZZSkin)

@property (nonatomic, copy, readonly) block_skin_t zz_skinConfig;

@end

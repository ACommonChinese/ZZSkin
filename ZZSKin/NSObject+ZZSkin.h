//
//  NSObject+ZZSkin.h
//  Demo
//
//  Created by 刘威振 on 8/29/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^block_id_t)(id item);
typedef NSObject * (^block_skin_t)(block_id_t blockConfig);
// typedef id (^block_tag_skin_t)(NSString *tag, block_id_t blockConfig);

@interface NSObject (ZZSkin)

@property (nonatomic, copy, readonly) block_skin_t zz_skinConfig;
// @property (nonatomic, copy, readonly) block_tag_skin_t zz_configWithTag;

@end

//
//  ZZSkin.h
//  Demo
//
//  Created by 刘威振 on 8/29/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ZZSkin.h"

@interface ZZSkin : NSObject

@property (nonatomic, weak) id master;

- (void)addSkinConfig:(block_id_t)skinConfig;
- (void)change;


@end

//
//  ZZSkinManager.h
//  Demo
//
//  Created by liuxing8807@126.com on 8/29/16.
//  Copyright © 2016 liuweizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+ZZSkin.h"

#define ZZSkinTypeNormal @"ZZSkinTypeNormal"
#define ZZSkinTypeRed @"ZZSkinTypeRed"
#define ZZSkinTypeGreen @"ZZSkinTypeGreen"
#define ZZSkinTypeBlue @"ZZSkinTypeBlue"

#define ZZSkinChangingNotificaiton @"ZZThemeChangingNotificaiton"
#define ZZSkinCurrentTag @"ZZSkinCurrentTag"

@interface ZZSkinManager : NSObject

/**
 * {key: tagName, value: dictionary}
 */
@property (nonatomic) NSMutableDictionary *jsonInfo;

@property (nonatomic, copy, readonly) NSString *currentTag;

+ (instancetype)sharedManager;

- (void)startSkin;

- (void)startSkin:(NSString *)skinTag;

+ (UIColor *)colorWithIdentifier:(NSString *)identifier;
+ (UIImage *)imageWithIdentifier:(NSString *)identifier;
+ (NSString *)stringWithIdentifier:(NSString *)identifier;

- (void)refresh:(NSObject *)targetObject;

- (void)addObject:(NSObject *)object configBlock:(block_id_t)configBlock;

@end

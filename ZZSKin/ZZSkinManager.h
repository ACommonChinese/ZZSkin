//
//  ZZSkinManager.h
//  Demo
//
//  Created by liuxing8807@126.com on 8/29/16.
//  Copyright © 2016 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+SkinString.h"
#import "ZZSkin.h"

@interface ZZSkinManager : NSObject


/**         / tag_1
 * jsonInfo - tag_2
 *          \ tag_3
 *          \ ...
 */
@property (nonatomic) NSMutableDictionary *jsonInfo;

@property (nonatomic, copy, readonly) NSString *currentTag;

+ (instancetype)sharedManager;

- (void)defaultSkin:(NSString *)skinTag;
- (void)startSkin:(NSString *)skinTag;
- (void)addSkin:(NSString *)skinTag jsonData:(NSData *)jsonData;

+ (UIColor *)colorWithIdentifier:(NSString *)identifier;
+ (UIImage *)imageWithIdentifier:(NSString *)identifier;
+ (NSString *)stringWithIdentifier:(NSString *)identifier;

@end

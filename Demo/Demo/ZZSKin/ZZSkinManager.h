//
//  ZZSkinManager.h
//  Demo
//
//  Created by 刘威振 on 8/29/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+SkinString.h"
#import "ZZSkin.h"

@interface ZZSkinManager : NSObject

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

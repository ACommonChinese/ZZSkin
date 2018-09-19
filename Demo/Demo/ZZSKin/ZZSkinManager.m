//
//  ZZSkinManager.m
//  Demo
//
//  Created by liuxing8807@126.com on 8/29/16.
//  Copyright © 2016 liuweizhen. All rights reserved.
//

#import "ZZSkinManager.h"
#import "ZZSkinExtern.h"
#import <UIKit/UIKit.h>

@interface ZZSkinManager()

@property (nonatomic, copy) NSString *currentTag;
@property (nonatomic) NSMutableSet *allTag;
@end

@implementation ZZSkinManager
@synthesize currentTag = _currentTag;

+ (instancetype)sharedManager {
    static ZZSkinManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ZZSkinManager alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *skin = [[NSUserDefaults standardUserDefaults] objectForKey:ZZSkinCurrentTag];
        if (skin) {
            self.currentTag = skin;
        }
    }
    return self;
}

- (void)setCurrentTag:(NSString *)currentTag {
    _currentTag = [currentTag copy];
    if ([self.allTag containsObject:currentTag] == NO) {
        [self.allTag addObject:currentTag];
    }
    [[NSUserDefaults standardUserDefaults] setObject:currentTag forKey:ZZSkinCurrentTag];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)defaultSkin:(NSString *)skinTag {
    _currentTag = [[NSUserDefaults standardUserDefaults] objectForKey:ZZSkinCurrentTag];
    if (_currentTag.length <= 0) {
        self.currentTag = skinTag;
    }
}

- (void)startSkin:(NSString *)skinTag {
    NSAssert([self.allTag containsObject:skinTag], @"所启用的主题不存在 - 请检查是否添加了主题: %@", skinTag);
    if ([self.currentTag isEqualToString:skinTag]) return;
    self.currentTag = skinTag;
    [[NSNotificationCenter defaultCenter] postNotificationName:ZZSkinChangingNotificaiton object:nil];
}

- (void)addSkin:(NSString *)skinTag jsonData:(NSData *)jsonData {
    if (skinTag == nil || jsonData == nil || [self.allTag containsObject:skinTag]) return;
    NSError *jsonError = nil;
    NSDictionary *skinDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    NSAssert(!jsonError, @"添加的主题json配置数据解析错误 - 错误描述");
    NSAssert(skinDict, @"添加的主题json配置数据解析为空 - 请检查");
    [self.allTag addObject:skinTag];
    [self.jsonInfo setObject:skinDict forKey:skinTag];
}

+ (UIColor *)colorWithIdentifier:(NSString *)identifier {
    if ([[ZZSkinManager sharedManager] currentTag] == nil) return nil;
    NSDictionary *info = [[[ZZSkinManager sharedManager] jsonInfo] objectForKey:[[ZZSkinManager sharedManager] currentTag]];
    NSString *str = [info[@"UIColor"] objectForKey:identifier];
    
    NSAssert(str.length > 0, @"JSON: Get color fail");
    return [UIColor colorWithString:str];
}

+ (UIImage *)imageWithIdentifier:(NSString *)identifier {
    if ([[ZZSkinManager sharedManager] currentTag] == nil) return nil;
    NSDictionary *info = [[[ZZSkinManager sharedManager] jsonInfo] objectForKey:[[ZZSkinManager sharedManager] currentTag]];
    NSString *str = [info[@"UIImage"] objectForKey:identifier];
    NSAssert(str.length > 0, @"JSON: Get Image fail");
    
    UIImage *image = [UIImage imageNamed:str];
    if (image == nil) {
        image = [UIImage imageWithContentsOfFile:str];
        // ... From documents of your custom path....
    }
    
    return image;
}

+ (NSString *)stringWithIdentifier:(NSString *)identifier {
    if ([[ZZSkinManager sharedManager] currentTag] == nil) return nil;
    NSDictionary *info = [[[ZZSkinManager sharedManager] jsonInfo] objectForKey:[[ZZSkinManager sharedManager] currentTag]];
    NSString *str = [info[@"NSString"] objectForKey:identifier];
    NSAssert(str.length > 0, @"JSON: Get String fail");
    
    return str;
}

LazyLoad_Common(NSMutableSet, allTag)
LazyLoad_Common(NSMutableDictionary, jsonInfo)

@end

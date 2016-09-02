//
//  ZZSkinManager.m
//  Demo
//
//  Created by 刘威振 on 8/29/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import "ZZSkinManager.h"
#import "ZZSkinExtern.h"
#import <UIKit/UIKit.h>

@interface ZZSkinManager()

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
            self.currentSkin = skin;
        }
    }
    return self;
}

- (void)setCurrentSkin:(NSString *)currentTag {
    _currentTag = [currentTag copy];
    if ([self.allTag containsObject:currentTag] == NO) {
        [self.allTag addObject:currentTag];
        [[NSUserDefaults standardUserDefaults] setObject:currentTag forKey:ZZSkinCurrentTag];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)startSkin:(NSString *)skinTag {
    NSAssert([self.allTag containsObject:skinTag], @"所启用的主题不存在 - 请检查是否添加了主题: %@", skinTag);
    if ([self.currentTag isEqualToString:skinTag]) return;
    self.currentTag = skinTag;
    [[NSNotificationCenter defaultCenter] postNotificationName:ZZSkinChangingNotificaiton object:nil];
}

- (void)addSkin:(NSString *)skinTag jsonData:(NSData *)jsonData {
    if (skinTag == nil || jsonData == nil) return;
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
    
    return [UIImage imageNamed:str];
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

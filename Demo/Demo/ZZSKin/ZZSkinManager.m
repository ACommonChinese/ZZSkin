//
//  ZZSkinManager.m
//  Demo
//
//  Created by liuxing8807@126.com on 8/29/16.
//  Copyright © 2016 liuweizhen. All rights reserved.
//

#import "ZZSkinManager.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface NSObject (ZZSkinConfigBlocks)

- (NSMutableArray *)zz_configBlockArray;

@end

@implementation NSObject (ZZSkinConfigBlocks)

static char kSkinConfigBlocksKey;

- (NSMutableArray *)zz_configBlockArray {
    NSMutableArray *configBlockArray = objc_getAssociatedObject(self, &kSkinConfigBlocksKey);
    if (!configBlockArray) {
        configBlockArray = [NSMutableArray array];
        objc_setAssociatedObject(self, &kSkinConfigBlocksKey, configBlockArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return configBlockArray;
}

@end

@interface ZZSkinManager()

@property (nonatomic, copy) NSString *currentTag;

@property (nonatomic, strong) NSMapTable *weakSkinMap;

@end

@implementation ZZSkinManager

@synthesize currentTag = _currentTag;

+ (instancetype)sharedManager {
    static ZZSkinManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ZZSkinManager alloc] init];
        _manager.weakSkinMap = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory];
        [[NSNotificationCenter defaultCenter] addObserver:_manager selector:@selector(skinChangingNotificaiton:) name:ZZSkinChangingNotificaiton object:nil];
    });
    return _manager;
}

- (void)skinChangingNotificaiton:(NSNotification *)notification {
    for (NSObject *key in self.weakSkinMap.keyEnumerator) {
        NSArray *value = [key zz_configBlockArray];
        for (block_id_t block in value) {
            if (block) {
                block(key);
            }
        }
    }
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

- (NSString *)currentTag {
    if (!_currentTag) {
        _currentTag = [[NSUserDefaults standardUserDefaults] objectForKey:ZZSkinCurrentTag];
    }
    return _currentTag;
}

- (void)setCurrentTag:(NSString *)currentTag {
    if (!currentTag || [_currentTag isEqualToString:currentTag]) {
        return;
    }
    _currentTag = [currentTag copy];
    [[NSUserDefaults standardUserDefaults] setObject:currentTag forKey:ZZSkinCurrentTag];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)startSkin {
    [self startSkin:self.currentTag];
}

- (void)startSkin:(NSString *)skinTag {
    [self startSkin:skinTag jsonData:nil];
}

- (void)startSkin:(NSString *)skinTag jsonData:(NSData *)jsonData {
    
    if ([self.currentTag isEqualToString:skinTag] && [self.jsonInfo objectForKey:skinTag]) {
        return;
    }
    
    NSString *targetTag = skinTag;
    NSData *targetData = jsonData;
    
    if (!targetTag) {
        targetTag = ZZSkinTypeNormal;
    }
    
    if (!targetData) {
        if ([targetTag isEqualToString:ZZSkinTypeNormal]) {
            targetData = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"tag_normal_json.json"]];
        } else if ([targetTag isEqualToString:ZZSkinTypeRed]) {
            targetData = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"tag_red_json.json"]];
        } else if ([targetTag isEqualToString:ZZSkinTypeGreen]) {
            targetData = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"tag_green_json.json"]];
        } else if ([targetTag isEqualToString:ZZSkinTypeBlue]) {
            targetData = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"tag_blue_json.json"]];
        } else {
            NSLog(@"OOOps, can't find target resource: %@", skinTag);
            return;
        }
    }
    
    self.currentTag = targetTag;
    
    NSError *jsonError = nil;
    NSDictionary *skinDict = [NSJSONSerialization JSONObjectWithData:targetData options:NSJSONReadingMutableContainers error:&jsonError];
    NSAssert(!jsonError, @"添加的主题json配置数据解析错误 - 错误描述");
    NSAssert(skinDict, @"添加的主题json配置数据解析为空 - 请检查");
    [self.jsonInfo setObject:skinDict forKey:targetTag];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZZSkinChangingNotificaiton object:nil];
}

- (void)refresh:(NSObject *)targetObject {
    if (targetObject) {
        NSArray *blocks = (NSArray *)[self.weakSkinMap objectForKey:targetObject];
        if (blocks && blocks.count > 0) {
            for (block_id_t configBlock in blocks) {
                configBlock(targetObject);
            }
        }
    }
}

+ (UIColor *)colorWithIdentifier:(NSString *)identifier {
    if ([[ZZSkinManager sharedManager] currentTag] == nil) return nil;
    NSDictionary *info = [[[ZZSkinManager sharedManager] jsonInfo] objectForKey:[[ZZSkinManager sharedManager] currentTag]];
    NSString *str = [info[@"UIColor"] objectForKey:identifier];
    
    NSAssert(str.length > 0, @"JSON: Get color fail");
    return [self colorWithString:str];
}

+ (UIImage *)imageWithIdentifier:(NSString *)identifier {
    if ([[ZZSkinManager sharedManager] currentTag] == nil) return nil;
    NSDictionary *info = [[[ZZSkinManager sharedManager] jsonInfo] objectForKey:[[ZZSkinManager sharedManager] currentTag]];
    NSString *str = [info[@"UIImage"] objectForKey:identifier];
    NSAssert(str.length > 0, @"JSON: Get Image fail");
    
    UIImage *image = [UIImage imageNamed:str];
    NSAssert(image, @"Can't find target image: %@", str);
    
    return image;
}

+ (NSString *)stringWithIdentifier:(NSString *)identifier {
    if ([[ZZSkinManager sharedManager] currentTag] == nil) return nil;
    NSDictionary *info = [[[ZZSkinManager sharedManager] jsonInfo] objectForKey:[[ZZSkinManager sharedManager] currentTag]];
    NSString *str = [info[@"NSString"] objectForKey:identifier];
    NSAssert(str.length > 0, @"JSON: Get String fail");
    
    return str;
}

- (void)addObject:(NSObject *)object configBlock:(block_id_t)configBlock {
    [[object zz_configBlockArray] addObject:configBlock];
    [self.weakSkinMap setObject:[object zz_configBlockArray] forKey:object];
}

- (NSMutableDictionary *)jsonInfo {
    if (!_jsonInfo) {
        _jsonInfo = [[NSMutableDictionary alloc] init];
    }
    return _jsonInfo;
}


+ (UIColor *)colorWithString:(NSString *)colorStr {
    NSString *colorString = [[colorStr stringByReplacingOccurrencesOfString:@"#" withString: @""] uppercaseString];
    
    CGFloat alpha, red, blue, green;
    
    switch ([colorString length]) {
        case 0:
            return nil;
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            alpha = red = blue = green = 0;
            break;
    }
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0f;
}

@end

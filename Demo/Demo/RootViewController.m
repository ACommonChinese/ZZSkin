//
//  RootViewController.m
//  Demo
//
//  Created by liuxing8807@126.com on 8/29/16.
//  Copyright © 2016 liuweizhen. All rights reserved.
//

#import "RootViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ZZSkinManager.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    OneViewController *vc1 = [[OneViewController alloc] init];
    UITabBarItem *item = [[UITabBarItem alloc] init];
    item.title = @"Alipay";
    item.image = [[UIImage imageNamed:@"支付宝_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    item.zz_skinConfig(^(UITabBarItem *item) {
        item.selectedImage = [[ZZSkinManager imageWithIdentifier:@"ident3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [ZZSkinManager colorWithIdentifier:@"ident1"]} forState:UIControlStateSelected];
    });
    vc1.tabBarItem = item;
    
    TwoViewController *vc2 = [[TwoViewController alloc] init];
    item = [[UITabBarItem alloc] init];
    item.title = @"JD";
    item.image = [[UIImage imageNamed:@"京东_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.zz_skinConfig(^(UITabBarItem *item) {
        item.selectedImage = [[ZZSkinManager imageWithIdentifier:@"ident4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [ZZSkinManager colorWithIdentifier:@"ident1"]} forState:UIControlStateSelected];
    });
    vc2.tabBarItem = item;
    
    self.viewControllers = @[vc1, [[UINavigationController alloc] initWithRootViewController:vc2]];
}

@end

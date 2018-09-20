//
//  OneViewController.m
//  Demo
//
//  Created by liuxing8807@126.com on 8/29/16.
//  Copyright © 2016 liuweizhen. All rights reserved.
//

#import "OneViewController.h"
#import "ZZSkinManager.h"
#import <UIKit/UIKit.h>

@interface OneViewController ()

@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIButton *greenButton;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic, assign) CGFloat fontSize;

@end

@implementation OneViewController

- (IBAction)redButtonClick:(id)sender {
    [[ZZSkinManager sharedManager] startSkin:ZZSkinTypeRed];
}

- (IBAction)greenButtonClick:(id)sender {
    [[ZZSkinManager sharedManager] startSkin:ZZSkinTypeGreen];
}

- (IBAction)blueButtonClick:(id)sender {
    [[ZZSkinManager sharedManager] startSkin:ZZSkinTypeBlue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.view.zz_skinConfig(^(UIView *item) {
        // item.backgroundColor = [ZZSkinManager colorWithIdentifier:@"ident1"];
    }).zz_skinConfig(^(UIView *item) {
        // item.backgroundColor = [ZZSkinManager colorWithIdentifier:@"ident2"];
    });
    
    self.redButton.layer.borderWidth = self.greenButton.layer.borderWidth = self.blueButton.layer.borderWidth = 2;
    block_id_t config = ^(UIButton *button) {
        UIColor *color = [ZZSkinManager colorWithIdentifier:@"ident1"];
        button.layer.borderColor = [color CGColor];
        [button setTitleColor:color forState:UIControlStateNormal];
    };
    self.redButton.zz_skinConfig(config);
    self.greenButton.zz_skinConfig(config);
    self.blueButton.zz_skinConfig(config);
    
    self.fontSize = 50.0;
    
    self.label.zz_skinConfig(^(UILabel *label) {
        label.textColor = [ZZSkinManager colorWithIdentifier:@"ident1"];
    }).zz_skinConfig(^(UILabel *label) {
        label.text = [ZZSkinManager stringWithIdentifier:@"ident1"];
        
        label.font = [UIFont systemFontOfSize:self.fontSize];
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.fontSize = self.fontSize == 32.0 ? 50.0 : 32.0;
    
    [self.label zz_refresh];
}

@end

//
//  TwoCell.m
//  Demo
//
//  Created by 刘威振 on 9/2/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import "TwoCell.h"
#import "ZZSkinManager.h"

@interface TwoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation TwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    [self setup];
}

- (void)setup {
    self.icon.zz_skinConfig(^(UIImageView *imageView) {
        imageView.image = [ZZSkinManager imageWithIdentifier:@"ident1"];
    });
    self.label.zz_skinConfig(^(UILabel *label) {
        label.textColor = [ZZSkinManager colorWithIdentifier:@"ident1"];
    });
}

@end

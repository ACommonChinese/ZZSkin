//
//  ChildViewController.m
//  Demo
//
//  Created by liuxing8807@126.com on 9/2/16.
//  Copyright © 2016 liuweizhen. All rights reserved.
//

#import "ChildViewController.h"
#import "ZZSkinManager.h"

@interface ChildViewController ()

@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIButton *greenButton;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.zz_skinConfig(^(UIImageView *imageView) {
        imageView.image = [ZZSkinManager imageWithIdentifier:@"ident2"];
    });
    
    self.view.zz_skinConfig(^(UIView *view) {
        view.backgroundColor = [ZZSkinManager colorWithIdentifier:@"ident1"];
    });
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(0, 0, 60, 40);
    backButton.zz_skinConfig(^(UIButton *button) {
        [button setTitleColor:[ZZSkinManager colorWithIdentifier:@"ident1"] forState:UIControlStateNormal];
        [button setTitle:[ZZSkinManager stringWithIdentifier:@"ident2"] forState:UIControlStateNormal];
    });
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)redButtonClick:(id)sender {
    [[ZZSkinManager sharedManager] startSkin:ZZSkinTypeRed];
}

- (IBAction)greenButtonClick:(id)sender {
    [[ZZSkinManager sharedManager] startSkin:ZZSkinTypeGreen];
}

- (IBAction)blueButtonClick:(id)sender {
    [[ZZSkinManager sharedManager] startSkin:ZZSkinTypeBlue];
}

@end

//
//  TwoViewController.m
//  Demo
//
//  Created by liuxing8807@126.com on 8/29/16.
//  Copyright © 2016 liuweizhen. All rights reserved.
//

#import "TwoViewController.h"
#import "NSObject+ZZSkin.h"
#import "TwoCell.h"
#import "ChildViewController.h"
#import "ZZSkinManager.h"

@interface TwoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.navigationItem.zz_skinConfig(^(UINavigationItem *navigationItem) {
        navigationItem.title = [ZZSkinManager stringWithIdentifier:@"ident2"];
    });
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    TwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TwoCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChildViewController *controller = [[ChildViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end

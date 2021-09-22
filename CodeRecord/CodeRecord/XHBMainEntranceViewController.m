//
//  XHBMainEntranceViewController.m
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/17.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "XHBMainEntranceViewController.h"
#import "ViewController.h"

@interface XHBMainEntranceViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation XHBMainEntranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *customModalBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [customModalBtn setTitle:@"自定义模态转场" forState:(UIControlStateNormal)];
    [customModalBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [customModalBtn addTarget:self action:@selector(clickCustomModalAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [customModalBtn sizeToFit];
    customModalBtn.center = (CGPoint){self.view.width / 2, self.view.height / 2};
    [self.view addSubview:customModalBtn];

    UIButton *customPopupBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [customPopupBtn setTitle:@"自定义进出场" forState:(UIControlStateNormal)];
    [customPopupBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [customPopupBtn addTarget:self action:@selector(clickCustomPopupAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [customPopupBtn sizeToFit];
    customPopupBtn.center = (CGPoint){self.view.width / 2, customModalBtn.bottom + 20};
    [self.view addSubview:customPopupBtn];
}

- (void)clickCustomModalAction:(UIButton *)sender {
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
//    ViewController1 *vc = [[ViewController1 alloc] init];
    XHBCustomModalDirectionTransitioningConfiguration *config = [[XHBCustomModalDirectionTransitioningConfiguration alloc] init];
    config.effect = YES;
    config.duration = 0.5;
    config.displayedSize = (CGSize){300,300};
    config.direction = XHBTransitionDirectionCenter;
    [self customModalPresentViewController:navCtrl configuration:config completion:nil];
}

- (void)clickCustomPopupAction:(UIButton *)sender {
    
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    navCtrl.navigationBar.barTintColor = [UIColor randomBackgroundColor];
    XHBCustomModalDirectionTransitioningConfiguration *config = [[XHBCustomModalDirectionTransitioningConfiguration alloc] init];
    config.duration = 0.3;
    config.direction = XHBTransitionDirectionBottom;
    config.transitioning = NO;
    config.displayedSize = (CGSize){self.view.width,self.view.height / 2};
    [self showViewController:navCtrl configuration:config];
}

@end

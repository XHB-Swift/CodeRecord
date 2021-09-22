//
//  ViewController.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/16.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import "ViewController.h"

//https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F8d8e817580a3bb029b50a4f9bb75e079718534222b4af-RM27w3_fw658&refer=http%3A%2F%2Fhbimg.b0.upaiyun.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1634462884&t=1668514c3955e3532b6a31f24d83d7a7

#define TestImageUrl1 (@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F8d8e817580a3bb029b50a4f9bb75e079718534222b4af-RM27w3_fw658&refer=http%3A%2F%2Fhbimg.b0.upaiyun.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1634462884&t=1668514c3955e3532b6a31f24d83d7a7")


@interface ViewController1 ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *returnButton;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ViewController1";
    self.view.backgroundColor = [UIColor randomBackgroundColor];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.returnButton];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.backButton.x = 50;
    self.backButton.y = self.navigationController.navigationBar.bottom + 10;
    
    self.returnButton.x = self.backButton.x;
    self.returnButton.y = self.backButton.bottom + 10;
}

- (void)backAction:(UIButton *)sender {
//    [self dismissCustomModalAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)returnButtonAction:(UIButton *)sender {
    [self.navigationController disapear];
}

- (UIButton *)backButton {
    
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_backButton setTitle:@"返回" forState:(UIControlStateNormal)];
        [_backButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_backButton sizeToFit];
    }
    
    return _backButton;
}

- (UIButton *)returnButton {
    
    if (!_returnButton) {
        _returnButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_returnButton setTitle:@"退出" forState:(UIControlStateNormal)];
        [_returnButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_returnButton addTarget:self action:@selector(returnButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_returnButton sizeToFit];
    }
    
    return _returnButton;
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ViewController";
    self.view.backgroundColor = [UIColor whiteColor];
    UISwitch *switchCtrl = [[UISwitch alloc] initWithFrame:(CGRect){(self.view.width-60)/2,50,60,30}];
    switchCtrl.on = NO;
    [switchCtrl addTarget:self action:@selector(switchCtrlAction:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:switchCtrl];
    
    [self.view theme_setBackgroundColor:XHBThemeMakeNoAlphaColor(@"000000") forStyle:XHBThemeStyleDark inScene:self];
    [self.view theme_setBackgroundColor:XHBThemeMakeNoAlphaColor(@"FFFFFF") forStyle:XHBThemeStyleLight inScene:self];
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){10,90,60,60}];
    testView.backgroundColor = [UIColor colorWithHexString:@"668B8B"];
    [testView theme_setBackgroundColor:XHBThemeMakeNoAlphaColor(@"F8F8FF") forStyle:XHBThemeStyleDark inScene:self];
    [testView theme_setBackgroundColor:XHBThemeMakeNoAlphaColor(@"668B8B") forStyle:XHBThemeStyleLight inScene:self];
    [self.view addSubview:testView];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    textLabel.text = [NSString stringWithRoundedNumber:@(192205678) digit:3 unitSymbol:@"万"];
    textLabel.textColor = [UIColor blackColor];
    [textLabel sizeToFit];
    textLabel.x = testView.right + 50;
    textLabel.y = testView.y + 30;
    [textLabel theme_setTextColor:XHBThemeMakeNoAlphaColor(@"000000") forStyle:XHBThemeStyleLight inScene:self];
    [textLabel theme_setTextColor:XHBThemeMakeNoAlphaColor(@"FFFFFF") forStyle:XHBThemeStyleDark inScene:self];
    [self.view addSubview:textLabel];
    
    if (self.navigationController) {
        UIButton *navButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [navButton setTitle:@"导航" forState:(UIControlStateNormal)];
        [navButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [navButton addTarget:self action:@selector(navButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [navButton sizeToFit];
        navButton.centerX = textLabel.centerX;
        navButton.y = textLabel.bottom + 10;
        [self.view addSubview:navButton];
        
        UIButton *returnButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [returnButton setTitle:@"退出" forState:(UIControlStateNormal)];
        [returnButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [returnButton addTarget:self action:@selector(returnButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [returnButton sizeToFit];
        returnButton.centerX = navButton.centerX;
        returnButton.y = navButton.bottom + 10;
        [self.view addSubview:returnButton];
    }
    
}

- (void)switchCtrlAction:(UISwitch *)sender {
    
    XHBThemeStyle style = sender.isOn ? XHBThemeStyleDark : XHBThemeStyleLight;
    [[XHBThemeManager sharedManager] switchToStyle:style];
}

- (void)navButtonAction:(UIButton *)sender {
    ViewController1 *vc1 = [[ViewController1 alloc] init];
    [self.navigationController pushViewController:vc1 animated:YES];
}

- (void)returnButtonAction:(UIButton *)sender {
    [self.navigationController disapear];
}

@end

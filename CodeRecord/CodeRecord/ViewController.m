//
//  ViewController.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/16.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import "ViewController.h"
#import "XHBThemeHeaders.h"
#import "XHBUIKitHeaders.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    textLabel.text = @"123456";
    textLabel.textColor = [UIColor blackColor];
    [textLabel sizeToFit];
    textLabel.x = testView.right + 50;
    textLabel.y = testView.y + 30;
    [textLabel theme_setTextColor:XHBThemeMakeNoAlphaColor(@"000000") forStyle:XHBThemeStyleLight inScene:self];
    [textLabel theme_setTextColor:XHBThemeMakeNoAlphaColor(@"FFFFFF") forStyle:XHBThemeStyleDark inScene:self];
    [self.view addSubview:textLabel];
}

- (void)switchCtrlAction:(UISwitch *)sender {
    
    XHBThemeStyle style = sender.isOn ? XHBThemeStyleDark : XHBThemeStyleLight;
    [[XHBThemeManager sharedManager] switchToStyle:style];
}


@end

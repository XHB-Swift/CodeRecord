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
#import "NSObject+XHBExtension.h"
#import "XHBCustomModalDirectionTransitioningConfiguration.h"

@interface ViewController1 : UIViewController

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:({
        
        UIButton *back = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [back setTitle:@"返回" forState:(UIControlStateNormal)];
        [back setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [back addTarget:self action:@selector(backAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [back sizeToFit];
        back.origin = (CGPoint){50,50};
        
        back;
    })];
}

- (void)backAction:(UIButton *)sender {
    [self dismissCustomModalAnimated:YES completion:nil];
}

@end

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
    textLabel.text = [NSString stringWithRoundedNumber:@(192205678) digit:3 unitSymbol:@"万"];
    textLabel.textColor = [UIColor blackColor];
    [textLabel sizeToFit];
    textLabel.x = testView.right + 50;
    textLabel.y = testView.y + 30;
    [textLabel theme_setTextColor:XHBThemeMakeNoAlphaColor(@"000000") forStyle:XHBThemeStyleLight inScene:self];
    [textLabel theme_setTextColor:XHBThemeMakeNoAlphaColor(@"FFFFFF") forStyle:XHBThemeStyleDark inScene:self];
    [self.view addSubview:textLabel];
    
    
    [self.view addSubview:({
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [button setTitle:@"自定义模态转场" forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(clickCustomModalAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [button sizeToFit];
        button.center = (CGPoint){self.view.width / 2, self.view.height / 2};
        
        button;
        
    })];
}

- (void)clickCustomModalAction:(UIButton *)sender {
    ViewController1 *vc = [[ViewController1 alloc] init];
    XHBCustomModalDirectionTransitioningConfiguration *config = [[XHBCustomModalDirectionTransitioningConfiguration alloc] init];
    config.effect = YES;
    config.duration = 0.5;
    config.displayedSize = (CGSize){300,300};
    config.direction = XHBTransitionDirectionCenter;
    [self customModalPresentViewController:vc configuration:config completion:nil];
}

- (void)switchCtrlAction:(UISwitch *)sender {
    
    XHBThemeStyle style = sender.isOn ? XHBThemeStyleDark : XHBThemeStyleLight;
    [[XHBThemeManager sharedManager] switchToStyle:style];
}


@end

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
    
    [self.view theme_setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:1] forStyle:XHBThemeStyleDark inScene:self];
    [self.view theme_setBackgroundColor:[UIColor colorWithHexString:@"FFFFFF" alpha:1] forStyle:XHBThemeStyleLight inScene:self];
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){10,90,60,60}];
    [testView theme_setBackgroundColor:[UIColor colorWithHexString:@"F8F8FF" alpha:1] forStyle:XHBThemeStyleDark inScene:self];
    [testView theme_setBackgroundColor:[UIColor colorWithHexString:@"668B8B" alpha:1] forStyle:XHBThemeStyleLight inScene:self];
    [self.view addSubview:testView];
    [self switchCtrlAction:switchCtrl];
}

- (void)switchCtrlAction:(UISwitch *)sender {
    
    XHBThemeStyle style = sender.isOn ? XHBThemeStyleDark : XHBThemeStyleLight;
    [[XHBThemeManager sharedManager] switchToStyle:style];
}


@end

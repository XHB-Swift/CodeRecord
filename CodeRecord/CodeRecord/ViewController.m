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

#define XHBThemeNameDark  (@"XHBThemeNameDark")
#define XHBThemeNameLight (@"XHBThemeNameLight")

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwitch *switchCtrl = [[UISwitch alloc] initWithFrame:(CGRect){(self.view.width-60)/2,50,60,30}];
    [switchCtrl addTarget:self action:@selector(switchCtrlAction:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:switchCtrl];
    
    [self.view theme_setBackgroundColor:[UIColor colorWithHexString:@"FFFFFF" alpha:1] forName:XHBThemeNameLight];
    [self.view theme_setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:1] forName:XHBThemeNameDark];
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){10,90,60,60}];
    [testView theme_setBackgroundColor:[UIColor colorWithHexString:@"F8F8FF" alpha:1] forName:XHBThemeNameDark];
    [testView theme_setBackgroundColor:[UIColor colorWithHexString:@"668B8B" alpha:1] forName:XHBThemeNameLight];
    [self.view addSubview:testView];
    [self switchCtrlAction:switchCtrl];
}

- (void)switchCtrlAction:(UISwitch *)sender {
    
    NSString *themeName = sender.isOn ? XHBThemeNameDark : XHBThemeNameLight;
    [[XHBThemeManager sharedManager] updateThemeForName:themeName];
}


@end

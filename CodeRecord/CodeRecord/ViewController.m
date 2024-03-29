//
//  ViewController.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/16.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import "ViewController.h"
#import "UIView+XHBLevelWeight.h"
#import "NSObject+XHBExtension.h"

#import "XHBTweenEasing.h"
#import "UIView+XHBTweenAnimation.h"

#import "XHBStateMachine.h"
#import "XHBUIBlockObserver.h"

//https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F8d8e817580a3bb029b50a4f9bb75e079718534222b4af-RM27w3_fw658&refer=http%3A%2F%2Fhbimg.b0.upaiyun.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1634462884&t=1668514c3955e3532b6a31f24d83d7a7

#define TestImageUrl1 (@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F8d8e817580a3bb029b50a4f9bb75e079718534222b4af-RM27w3_fw658&refer=http%3A%2F%2Fhbimg.b0.upaiyun.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1634462884&t=1668514c3955e3532b6a31f24d83d7a7")

#if defined(__cplusplus)

#define let auto const

#else

#define let const __auto_type

#endif

#if defined(__cplusplus)

#define var auto

#else

#define var __auto_type

#endif

@interface Model : NSObject

@property (nonatomic, strong) NSString *str;
@property (nonatomic, strong) NSNumber *num;

@end

@implementation Model

- (NSString *)description {
    return [NSString stringWithFormat:@"str = %@, num = %@", self.str, self.num];
}

@end

@interface ViewController1 ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *returnButton;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ViewController1";
//    self.view.backgroundColor = [UIColor randomBackgroundColor];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.returnButton];
    
    [self setupLevelViews];
}

- (void)setupLevelViews {
    NSInteger lv1 = 1;
    NSInteger lv2 = 2;
    NSInteger lv3 = 3;
    UILabel *view1 = [[UILabel alloc] initWithFrame:(CGRect){10,10,50,50}];
    view1.text = @(lv3).stringValue;
    UILabel *view2 = [[UILabel alloc] initWithFrame:(CGRect){10,10,50,50}];
    view2.text = @(lv2).stringValue;
    UILabel *view3 = [[UILabel alloc] initWithFrame:(CGRect){10,10,50,50}];
    view3.text = @(lv1).stringValue;
    UILabel *view4 = [[UILabel alloc] initWithFrame:(CGRect){10,10,50,50}];
    view4.text = @(lv3).stringValue;
    UILabel *view5 = [[UILabel alloc] initWithFrame:(CGRect){10,10,50,50}];
    view5.text = @(lv2).stringValue;
    UILabel *view6 = [[UILabel alloc] initWithFrame:(CGRect){10,10,50,50}];
    view6.text = @(lv1).stringValue;
    
    [self.view addSubview:view1 levelWeight:lv3];
    [self.view addSubview:view2 levelWeight:lv2];
    [self.view addSubview:view3 levelWeight:lv1];
    [self.view addSubview:view4 levelWeight:lv3];
    [self.view addSubview:view5 levelWeight:lv2];
    [self.view addSubview:view6 levelWeight:lv1];
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

@property (nonatomic, strong) UIView *testView;
@property (nonatomic, strong) XHBStateMachine *stateMachine;
@property (nonatomic, strong) XHBUIBlockObserver *uiBlockObserver;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ViewController";
    self.view.backgroundColor = [UIColor whiteColor];
    [self test4Code];
    [self.uiBlockObserver startMonitoring];
}

- (void)test1Code {
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

- (void)test2Code {
    
    [self.view addSubview:({
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [button setTitle:@"开启动画" forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(openAnimationAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [button sizeToFit];
        button.origin = (CGPoint){50, 100};
        
        button;
    })];
    
    [self.view addSubview:({
        
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){150,100,100,100}];
        view.backgroundColor = [UIColor orangeColor];
        self.testView = view;
        
        view;
    })];
}

- (void)test3Code {
    NSArray<Model *> *models = @[
        ({
            Model *model = [[Model alloc] init];
            model.str = @"a";
            model.num = @1;
            model;
        }),
        ({
            Model *model = [[Model alloc] init];
            model.str = @"b";
            model.num = @2;
            model;
        }),
        ({
            Model *model = [[Model alloc] init];
            model.str = @"c";
            model.num = @3;
            model;
        }),
        ({
            Model *model = [[Model alloc] init];
            model.str = @"d";
            model.num = @4;
            model;
        }),
        ({
            Model *model = [[Model alloc] init];
            model.str = @"e";
            model.num = @5;
            model;
        })
    ];
    NSArray<NSNumber *> *numbers = [models mapUsingBlock:^id _Nonnull(Model * _Nonnull element) { return element.num; }];
    NSLog(@"numbers = %@", numbers);
    NSArray<Model *> *filterModels = [models filterUsingBlock:^BOOL(Model * _Nonnull element) {
        return [element.num compare:@3] == NSOrderedAscending;
    }];
    NSLog(@"filterModels = %@", filterModels);
}

- (void)test4Code {
    
    [self.view addSubview:({
        
        UIButton *testMachineButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [testMachineButton setTitle:@"Normal和Selected互相切换" forState:(UIControlStateNormal)];
        [testMachineButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [testMachineButton addTarget:self action:@selector(switchNormalSelectedAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [testMachineButton sizeToFit];
        testMachineButton.origin = (CGPoint){50,100};
        
        testMachineButton;
    })];
    
    [self.stateMachine registerEvent:@"UIButtonStateMachine"
                                from:@0
                                  to:@1
                          completion:^(id state) {
        NSLog(@"state = %@", state);
    }];
    [self.stateMachine registerEvent:@"UIButtonStateMachine"
                                from:@1
                                  to:@0
                          completion:^(id state) {
        NSLog(@"state = %@", state);
    }];
}

#pragma mark - Button Actions

- (void)openAnimationAction:(UIButton *)sender {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.testView xhb_tweenAnimationForKey:@"alpha"
                                       duration:5
                                         easing:[XHBTweenEasing bounceInOut]
                                       reversed:YES
                                             to:@(0)];
    });
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

- (void)switchNormalSelectedAction:(UIButton *)sender {
    [self.stateMachine triggerByEvent:@"UIButtonStateMachine"];
}

#pragma mark - Getter

- (XHBStateMachine *)stateMachine {
    
    if (!_stateMachine) {
        _stateMachine = [XHBStateMachine stateMachineWithState:@0];
    }
    
    return _stateMachine;
}

- (XHBUIBlockObserver *)uiBlockObserver {
    
    if (!_uiBlockObserver) {
        _uiBlockObserver = [[XHBUIBlockObserver alloc] init];
    }
    
    return _uiBlockObserver;
}

@end

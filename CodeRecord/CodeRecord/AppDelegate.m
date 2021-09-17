//
//  AppDelegate.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/16.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import "AppDelegate.h"
#import "XHBMainEntranceViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    XHBMainEntranceViewController *mainEntrance = [[XHBMainEntranceViewController alloc] init];
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:mainEntrance];
    self.window.rootViewController = navCtrl;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end

//
//  XHBThemeManager.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "XHBThemeManager.h"

XHBThemeStyle const XHBThemeStyleDark = @"XHBThemeStyleDark";
XHBThemeStyle const XHBThemeStyleLight = @"XHBThemeStyleLight";

@implementation XHBTheme

@end

@interface XHBThemeObject: NSObject

@property (nonatomic, weak) id<XHBThemeUpdatable> updatable;
@property (nonatomic, strong) NSString *updatableId;
@property (nonatomic, strong) NSMutableDictionary<XHBThemeStyle, XHBTheme *> *themeInfo;

@end

@implementation XHBThemeObject

- (instancetype)initWithUpdatable:(id<XHBThemeUpdatable>)updatable {
    
    if (self = [super init]) {
        _updatable = updatable;
        _updatableId = [NSString stringWithFormat:@"%@",updatable];
        _themeInfo = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)updateThemeForStyle:(XHBThemeStyle)style {
    if (![self.updatable respondsToSelector:@selector(updateTheme:forStyle:)]) {
        return;
    }
    XHBTheme *theme = self.themeInfo[style];
    if (![theme isKindOfClass:[XHBTheme class]]) {
        return;
    }
    [self.updatable updateTheme:theme forStyle:style];
}

@end

@interface XHBThemeScene: NSObject

@property (nonatomic, strong) NSString *sceneId;
@property (nonatomic, strong) NSMutableDictionary<NSString *, XHBThemeObject *> *themeObjects;

@end

@implementation XHBThemeScene

- (instancetype)initWithSceneId:(NSString *)sceneId {
    
    if (self = [super init]) {
        _sceneId = [NSString stringWithFormat:@"%@", sceneId];
        _themeObjects = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)updateThemeForStyle:(XHBThemeStyle)style {
    if (self.themeObjects.count == 0) {
        return;
    }
    [self.themeObjects enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key,
                                                           XHBThemeObject * _Nonnull obj,
                                                           BOOL * _Nonnull stop) {
        [obj updateThemeForStyle:style];
    }];
}

@end

@interface XHBThemeManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, XHBThemeScene *> *themeScenes;

@end

static XHBThemeManager *manager = nil;

@implementation XHBThemeManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[super alloc] init];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

- (void)setTheme:(XHBTheme *)theme
           style:(XHBThemeStyle)style
         forView:(id<XHBThemeUpdatable>)view
         inScene:(id)scene {
    
    NSString *viewId = [NSString stringWithFormat:@"%@", view];
    NSString *sceneId = [NSString stringWithFormat:@"%@", scene];
    XHBThemeScene *themeScene = self.themeScenes[sceneId];
    if (themeScene == nil) {
        themeScene = [[XHBThemeScene alloc] initWithSceneId:sceneId];
        XHBThemeObject *themeObject = [[XHBThemeObject alloc] initWithUpdatable:view];
        themeObject.themeInfo[style] = theme;
        themeScene.themeObjects[viewId] = themeObject;
        self.themeScenes[sceneId] = themeScene;
    }else {
        XHBThemeObject *themeObject = themeScene.themeObjects[viewId];
        if (themeObject == nil) {
            themeObject = [[XHBThemeObject alloc] initWithUpdatable:view];
        }
        themeObject.themeInfo[style] = theme;
        themeScene.themeObjects[viewId] = themeObject;
    }
}

- (void)switchToStyle:(XHBThemeStyle)style {
    [self.themeScenes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key,
                                                          XHBThemeScene * _Nonnull scene,
                                                          BOOL * _Nonnull stop) {
        [scene updateThemeForStyle:style];
    }];
}

- (void)cleanForView:(id<XHBThemeUpdatable>)view inScene:(id)scene {
    NSString *sceneId = [NSString stringWithFormat:@"%@", scene];
    XHBThemeScene *themeScene = self.themeScenes[sceneId];
    NSString *viewId = [NSString stringWithFormat:@"%@", view];
    [themeScene.themeObjects removeObjectForKey:viewId];
}

- (void)cleanInScene:(id)scene {
    NSString *sceneId = [NSString stringWithFormat:@"%@", scene];
    [self.themeScenes removeObjectForKey:sceneId];
}

#pragma mark - Getter

- (NSMutableDictionary<NSString *,XHBThemeScene *> *)themeScenes {
    
    if (!_themeScenes) {
        _themeScenes = [NSMutableDictionary dictionary];
    }
    
    return _themeScenes;
}
    
@end

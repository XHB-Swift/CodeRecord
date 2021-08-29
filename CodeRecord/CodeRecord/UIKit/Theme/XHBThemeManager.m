//
//  XHBThemeManager.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "XHBThemeManager.h"

@interface XHBThemeModel : NSObject

@property (nonatomic, weak) __kindof UIView<XHBThemeObject> *view;
@property (nonatomic, strong) NSMutableDictionary<NSString *,id> *theme;

@end

@implementation XHBThemeModel

- (instancetype)init {
    
    if (self = [super init]) {
        _theme = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)setView:(__kindof UIView<XHBThemeObject> *)view {
    _view = view;
    if (!view) {
        [self.theme removeAllObjects];
    }
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[XHBThemeModel class]]) {
        return NO;
    }
    XHBThemeModel *model = (XHBThemeModel *)object;
    return (self.view != nil) && (model.view != nil) && (self.view == model.view);
}

@end

@interface XHBThemeManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *,NSMutableSet<XHBThemeModel *> *> *themeInfo;

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

- (void)setTheme:(NSDictionary<NSString *,id> *)theme forName:(NSString *)name view:(__kindof UIView<XHBThemeObject> *)view {
    if (!theme ||
        ![name isKindOfClass:[NSString class]] ||
        ![view isKindOfClass:[UIView class]]) {
        return;
    }
    NSMutableSet<XHBThemeModel *> *models = self.themeInfo[name];
    if (!models) {
        models = [NSMutableSet set];
    }
    if (theme) {
        if (models.count == 0) {
            XHBThemeModel *model = [[XHBThemeModel alloc] init];
            model.view = view;
            [model.theme addEntriesFromDictionary:theme];
            [models addObject:model];
        }else {
            while (YES) {
                XHBThemeModel *model = [models anyObject];
                if (model.view == view) {
                    if (theme) {
                        [model.theme addEntriesFromDictionary:theme];
                    }
                }else {
                    XHBThemeModel *model = [[XHBThemeModel alloc] init];
                    model.view = view;
                    [model.theme addEntriesFromDictionary:theme];
                    [models addObject:model];
                    break;
                }
            }
        }
    }
    self.themeInfo[name] = models;
}

- (nullable NSDictionary<NSString *,id> *)themeForName:(NSString *)name withView:(__kindof UIView<XHBThemeObject> *)view {
    if (![name isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (![view isKindOfClass:[UIView class]]) {
        return nil;
    }
    NSMutableSet<XHBThemeModel *> *models = self.themeInfo[name];
    __block NSDictionary<NSString *,id> *theme = nil;
    [models enumerateObjectsUsingBlock:^(XHBThemeModel * _Nonnull model,
                                         BOOL * _Nonnull stop) {
        if (model.view == view) {
            *stop = YES;
            theme = [model.theme copy];
        }
    }];
    return theme;
}

- (void)removeThemeForName:(NSString *)name {
    if (![name isKindOfClass:[NSString class]]) {
        return;
    }
    [self.themeInfo removeObjectForKey:name];
}

- (void)removeThemeForName:(NSString *)name view:(__kindof UIView<XHBThemeObject> *)view {
    [self removeThemeForName:name views:[NSArray arrayWithObjects:view, nil]];
}

- (void)removeThemeForName:(NSString *)name views:(NSArray<__kindof UIView<XHBThemeObject> *> *)views {
    if (![views isKindOfClass:[NSArray class]]) {
        return;
    }
    if (![name isKindOfClass:[NSString class]]) {
        return;
    }
    if (views.count == 0) {
        return;
    }
    NSMutableSet<XHBThemeModel *> *models = self.themeInfo[name];
    if (models.count == 0) {
        return;
    }
    [views enumerateObjectsUsingBlock:^(__kindof UIView<XHBThemeObject> * _Nonnull view,
                                        NSUInteger idx,
                                        BOOL * _Nonnull stop) {
        XHBThemeModel *model = [models anyObject];
        if (model.view == view) {
            [models removeObject:model];
        }
    }];
}

- (void)updateThemeForName:(NSString *)name {
    if (![name isKindOfClass:[NSString class]]) {
        return;
    }
    if (self.themeInfo.count == 0) {
        return;
    }
    NSMutableSet<XHBThemeModel *> *models = self.themeInfo[name];
    [models enumerateObjectsUsingBlock:^(XHBThemeModel * _Nonnull model,
                                         BOOL * _Nonnull stop) {
        __kindof UIView<XHBThemeObject> *view = model.view;
        if (![view respondsToSelector:@selector(shouldUpdateTheme:forName:)]) {
            return;
        }
        NSDictionary<NSString *, id> *theme = [model.theme copy];
        if (!theme) {
            return;
        }
        [view shouldUpdateTheme:theme forName:name];
    }];
}

#pragma mark - Getter

- (NSMutableDictionary<NSString *,NSMutableSet<XHBThemeModel *> *> *)themeInfo {
    
    if (!_themeInfo) {
        _themeInfo = [NSMutableDictionary dictionary];
    }
    
    return _themeInfo;
}
    
@end

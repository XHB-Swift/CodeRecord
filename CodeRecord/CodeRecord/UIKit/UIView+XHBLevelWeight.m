//
//  UIView+XHBLevelWeight.m
//  CodeRecord
//
//  Created by xiehongbiao on 2022/1/12.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import "UIView+XHBLevelWeight.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, strong, readwrite, nullable) NSNumber *levelWeight;

@end

@implementation UIView (XHBLevelWeight)

- (void)addSubview:(UIView *)view levelWeight:(NSInteger)levelWeight {
    if ([self.subviews containsObject:view]) {
        [view removeFromSuperview];
    }
    view.levelWeight = @(levelWeight);
    NSEnumerator<__kindof UIView *> *reversedEnumerator = self.subviews.reverseObjectEnumerator;
    UIView *subview = [reversedEnumerator nextObject];
    UIView *belowView = nil;
    while (subview != nil) {
        if (!subview.levelWeight) {
            subview = [reversedEnumerator nextObject];
            continue;
        }
        NSInteger level = [subview.levelWeight integerValue];
        if (level > levelWeight) {
            belowView = subview;
            subview = [reversedEnumerator nextObject];
        }else {
            [self insertSubview:view aboveSubview:subview];
            break;
        }
    }
    if (!view.superview) {
        if (belowView) {
            [self insertSubview:view belowSubview:belowView];
        }else {
            [self addSubview:view];
        }
    }
}

#pragma mark Setter & Getter

#define UIViewLevelWeightKey (@selector(levelWeight))

- (void)setLevelWeight:(NSNumber *)levelWeight {
    objc_setAssociatedObject(self, UIViewLevelWeightKey, levelWeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)levelWeight {
    return objc_getAssociatedObject(self, UIViewLevelWeightKey);
}

@end

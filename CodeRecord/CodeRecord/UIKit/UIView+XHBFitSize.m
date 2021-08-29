//
//  UIView+XHBFitSize.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "UIView+XHBFitSize.h"
#import "UIView+XHBBoxing.h"

@implementation UIView (XHBFitSize)

- (void)sizeToFitWithMaxWidth:(CGFloat)maxWidth {
    [self sizeToFitWithMaxWidth:maxWidth margin:0];
}

- (void)sizeToFitWithMaxWidth:(CGFloat)maxWidth margin:(CGFloat)margin {
    [self sizeToFit];
    CGFloat fitWidth = MIN(self.width + 2 * margin, maxWidth);
    self.width = fitWidth;
}

- (void)sizeToFitWithMaxHeight:(CGFloat)maxHeight {
    [self sizeToFitWithMaxHeight:maxHeight margin:0];
}

- (void)sizeToFitWithMaxHeight:(CGFloat)maxHeight margin:(CGFloat)margin {
    [self sizeToFit];
    CGFloat fitHeight = MIN(self.height + 2 * margin, maxHeight);
    self.height = fitHeight;
}

- (void)sizeToFitWithMaxSize:(CGSize)maxSize {
    [self sizeToFitWithMaxSize:maxSize inset:(UIEdgeInsetsZero)];
}

- (void)sizeToFitWithMaxSize:(CGSize)maxSize inset:(UIEdgeInsets)inset {
    [self sizeToFit];
    CGFloat fitWidth = MIN(self.width + inset.left + inset.right, maxSize.width);
    CGFloat fitHeight = MIN(self.height + inset.top + inset.bottom, maxSize.height);
    self.size = (CGSize){fitWidth,fitHeight};
}

@end

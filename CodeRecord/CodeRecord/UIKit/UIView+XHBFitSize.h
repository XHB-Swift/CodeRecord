//
//  UIView+XHBFitSize.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XHBFitSize)

- (void)sizeToFitWithMaxWidth:(CGFloat)maxWidth;
- (void)sizeToFitWithMaxWidth:(CGFloat)maxWidth margin:(CGFloat)margin;

- (void)sizeToFitWithMaxHeight:(CGFloat)maxHeight;
- (void)sizeToFitWithMaxHeight:(CGFloat)maxWidth margin:(CGFloat)margin;

- (void)sizeToFitWithMaxSize:(CGSize)maxSize;
- (void)sizeToFitWithMaxSize:(CGSize)maxSize inset:(UIEdgeInsets)inset;

@end

NS_ASSUME_NONNULL_END

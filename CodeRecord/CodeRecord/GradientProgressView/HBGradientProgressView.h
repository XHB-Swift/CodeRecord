//
//  HBGradientProgressView.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2022/4/16.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBGradientProgressView : UIView

XHB_PROPERTY_DEFINED_READONLY_STRONG(CAShapeLayer, backgroundLayer)
XHB_PROPERTY_DEFINED_READONLY_STRONG(CAShapeLayer, progressLayer)

XHB_PROPERTY_DEFINED_READWRITE_ASSIGN(CGFloat, progress)

- (void)setGradientColorStrings:(NSArray<NSString *> *)colorStrings;

- (void)setLocations:(NSArray<NSNumber *> *)locations;

- (void)setStartPoint:(CGPoint)startPoint;

- (void)setEndPoint:(CGPoint)endPoint;

- (UIBezierPath *)progressShapePath;

@end

NS_ASSUME_NONNULL_END

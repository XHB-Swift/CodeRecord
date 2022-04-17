//
//  HBLineGradientProgressView.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2022/4/16.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import "HBLineGradientProgressView.h"

@implementation HBLineGradientProgressView

@synthesize
backgroundLayer = _backgroundLayer,
progressLayer = _progressLayer;

- (UIBezierPath *)progressShapePath {
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    
    [linePath moveToPoint:(CGPoint){5, self.height / 2}];
    [linePath addLineToPoint:(CGPoint){self.width - 5, self.height / 2}];
    
    return linePath;
}

- (CAShapeLayer *)backgroundLayer {
    
    _backgroundLayer = [super backgroundLayer];
    _backgroundLayer.fillColor = [[UIColor clearColor] CGColor];
    _backgroundLayer.lineCap = kCALineCapRound;
    _backgroundLayer.lineWidth = self.height;
    
    return _backgroundLayer;
}

- (CAShapeLayer *)progressLayer {
    
    _progressLayer = [super progressLayer];
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = self.height;
    
    return _progressLayer;
}

@end

//
//  HBGradientProgressView.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2022/4/16.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import "HBGradientProgressView.h"

@interface HBGradientProgressView ()

XHB_PROPERTY_DEFINED_READWRITE_STRONG(CAShapeLayer, backgroundLayer)
XHB_PROPERTY_DEFINED_READWRITE_STRONG(CAShapeLayer, progressLayer)
XHB_PROPERTY_DEFINED_READWRITE_STRONG(CAGradientLayer, gradientLayer)

@end

@implementation HBGradientProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupSublayers];
    }
    
    return self;
}

- (void)setupSublayers {
    [self.layer addSublayer:self.backgroundLayer];
    [self.layer addSublayer:self.gradientLayer];
    self.gradientLayer.mask = self.progressLayer;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    UIBezierPath *path = [self progressShapePath];
    self.backgroundLayer.path = [path CGPath];
    self.progressLayer.path = [path CGPath];
    self.backgroundLayer.frame = self.bounds;
    self.progressLayer.frame = self.bounds;
    self.gradientLayer.frame = self.bounds;
}

- (void)setProgress:(CGFloat)progress {
    _progress = MAX(MIN(progress, 1), 0);
    self.progressLayer.strokeEnd = _progress;
}

- (void)setGradientColorStrings:(NSArray<NSString *> *)colorStrings {
    if (![colorStrings isKindOfClass:[NSArray class]] || colorStrings.count == 0) {
        return;
    }
    NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colorStrings.count];
    for (NSString *colorString in colorStrings) {
        if (![colorString isKindOfClass:[NSString class]]) {
            continue;
        }
        UIColor *color = [UIColor colorWithHexString:colorString];
        [cgColors addObject:(__bridge id)[color CGColor]];
    }
    self.gradientLayer.colors = cgColors;
}

- (void)setLocations:(NSArray<NSNumber *> *)locations {
    if (![locations isKindOfClass:[NSArray class]] || locations.count == 0) {
        return;
    }
    self.gradientLayer.locations = locations;
}

- (void)setStartPoint:(CGPoint)startPoint {
    self.gradientLayer.startPoint = startPoint;
}

- (void)setEndPoint:(CGPoint)endPoint {
    self.gradientLayer.endPoint = endPoint;
}

- (UIBezierPath *)progressShapePath {
    NSAssert(NO, @"Subsclass must implement this method");
    return nil;
}

#pragma mark - Getter

- (CAShapeLayer *)backgroundLayer {
    
    if (!_backgroundLayer) {
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.strokeEnd = 1;
    }
    
    return _backgroundLayer;
}

- (CAShapeLayer *)progressLayer {
    
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeEnd = 0;
    }
    
    return _progressLayer;
}

- (CAGradientLayer *)gradientLayer {
    
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
    }
    
    return _gradientLayer;
}

@end

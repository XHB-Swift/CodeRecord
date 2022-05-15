//
//  XHBTweenInterpolator.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2022/5/14.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import "XHBTweenInterpolator.h"
#import "XHBTweenEasing.h"
#import "NSObject+XHBExtension.h"

#define XHBTweenCGRectArrayInit(varName) \
[NSMutableArray arrayWithObjects:\
           @(varName.origin.x),\
           @(varName.origin.y),\
           @(varName.size.width),\
           @(varName.size.height),\
           nil];

#define XHBTweenCGSizeArrayInit(varName) \
[NSMutableArray arrayWithObjects:\
           @(varName.width),\
           @(varName.height),\
           nil];

#define XHBTweenCGPointArrayInit(varName) \
[NSMutableArray arrayWithObjects:\
           @(varName.x),\
           @(varName.y),\
           nil];

#define XHBTWeenCGVectorArrayInit(varName) \
[NSMutableArray arrayWithObjects:\
           @(varName.dx),\
           @(varName.dy),\
           nil];

#define XHBTweenUIOffsetArrayInit(varName) \
[NSMutableArray arrayWithObjects: \
        @(varName.vertical), \
        @(varName.horizontal), \
        nil];

#define XHBTweenTransform3DArrayInit(varName) \
[NSMutableArray arrayWithObjects:\
           @(varName.m11), @(varName.m12), @(varName.m13), @(varName.m14),\
           @(varName.m21), @(varName.m22), @(varName.m23), @(varName.m24),\
           @(varName.m31), @(varName.m32), @(varName.m33), @(varName.m34),\
           @(varName.m41), @(varName.m42), @(varName.m43), @(varName.m44),\
           nil];

#define XHBTweenAffineTransformArrayInit(varName) \
[NSMutableArray arrayWithObjects: \
           @(varName.a), @(varName.b), @(varName.c), @(varName.d), \
           @(varName.tx), @(varName.ty), \
           nil];


@interface XHBTweenInterpolator ()

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) XHBTweenEasing *easing;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *v0;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *v1;
@property (nonatomic, assign) NSInteger typeBit;

@end

@implementation XHBTweenInterpolator

+ (instancetype)interpolatornWithDuration:(NSTimeInterval)duration
                                   easing:(XHBTweenEasing *)easing
                                     from:(id)from
                                       to:(id)to {
    return [[self alloc] initWithDuration:duration easing:easing from:from to:to];
}

- (instancetype)initWithDuration:(NSTimeInterval)duration
                          easing:(XHBTweenEasing *)easing
                            from:(id)from
                              to:(id)to {
    
    if (self = [super init]) {
        self.duration = duration;
        self.easing = easing;
        [self setupValuesForFrom:from to:to];
    }
    return self;
}

#pragma mark - Public

- (void)moveToTime:(NSTimeInterval)time {
    if ([self didMoveToEnd]) {
        if ([self.delegate respondsToSelector:@selector(interpolatorDidFinish:)]) {
            [self.delegate interpolatorDidFinish:self];
        }
        return;
    }
    
    if (time >= self.duration) {
        self.v0 = self.v1;
    } else {
        [self moveToNextWithT:time d:(self.duration - time)];
    }
    
    if ([self.delegate respondsToSelector:@selector(interpolator:didUpdateToValue:)]) {
        id value = [self recoveryToValue];
        if (value) {
            [self.delegate interpolator:self didUpdateToValue:value];
        }
    }
}

#pragma mark - Private

- (void)setupValuesForFrom:(id)from to:(id)to {
    if ([from isKindOfClass:[NSValue class]] &&
        [to isKindOfClass:[NSValue class]]) {
        NSValue *v0 = (NSValue *)from;
        NSValue *v1 = (NSValue *)to;
        
        if ([v0 isCGRectValue] && [v1 isCGRectValue]) {
            
            self.typeBit |= 0x1;
            CGRect v0_rect = [v0 CGRectValue];
            self.v0 = XHBTweenCGRectArrayInit(v0_rect)
            CGRect v1_rect = [v1 CGRectValue];
            self.v1 = XHBTweenCGRectArrayInit(v1_rect)
        } else if ([v0 isCGSizeValue] && [v1 isCGSizeValue]) {
            
            self.typeBit |= 0x10;
            CGSize v0_size = [v0 CGSizeValue];
            self.v0 = XHBTweenCGSizeArrayInit(v0_size)
            CGSize v1_size = [v1 CGSizeValue];
            self.v1 = XHBTweenCGSizeArrayInit(v1_size)
        } else if ([v0 isCGPointValue] && [v1 isCGPointValue]) {
            
            self.typeBit |= 0x100;
            CGPoint v0_point = [v0 CGPointValue];
            self.v0 = XHBTweenCGPointArrayInit(v0_point)
            CGPoint v1_point = [v1 CGPointValue];
            self.v1 = XHBTweenCGPointArrayInit(v1_point)
        } else if ([v0 isCGVectorValue] && [v1 isCGVectorValue]) {
            
            self.typeBit |= 0x1000;
            CGVector v0_vector = [v0 CGVectorValue];
            self.v0 = XHBTWeenCGVectorArrayInit(v0_vector)
            CGVector v1_vector = [v1 CGVectorValue];
            self.v1 = XHBTWeenCGVectorArrayInit(v1_vector)
        } else if ([v0 isKindOfClass:[NSNumber class]] && [v1 isKindOfClass:[NSNumber class]]) {
            
            self.typeBit |= 0x10000;
            self.v0 = [NSMutableArray arrayWithObjects:from, nil];
            self.v1 = [NSMutableArray arrayWithObjects:to, nil];
        } else if ([v0 isUIOffsetValue] && [v1 isUIOffsetValue]) {
            
            self.typeBit |= 0x100000;
            UIOffset v0_offset = [v0 UIOffsetValue];
            self.v0 = XHBTweenUIOffsetArrayInit(v0_offset)
            UIOffset v1_offset = [v1 UIOffsetValue];
            self.v1 = XHBTweenUIOffsetArrayInit(v1_offset)
        } else if ([v0 isCATransform3DValue] && [v1 isCATransform3DValue]) {
            
            self.typeBit |= 0x1000000;
            CATransform3D v0_3d = [v0 CATransform3DValue];
            self.v0 = XHBTweenTransform3DArrayInit(v0_3d);
            CATransform3D v1_3d = [v1 CATransform3DValue];
            self.v1 = XHBTweenTransform3DArrayInit(v1_3d);
        } else if ([v0 isCGAffineTransformValue] && [v1 isCGAffineTransformValue]) {
            
            self.typeBit |= 0x10000000;
            CGAffineTransform v0_transform = [v0 CGAffineTransformValue];
            self.v0 = XHBTweenAffineTransformArrayInit(v0_transform)
            CGAffineTransform v1_transform = [v1 CGAffineTransformValue];
            self.v1 = XHBTweenAffineTransformArrayInit(v1_transform)
        }
    } else if ([from isKindOfClass:[UIColor class]] && [to isKindOfClass:[UIColor class]]) {
        
        self.typeBit |= 0x100000000;
        UIColor *v0 = (UIColor *)from;
        UIColor *v1 = (UIColor *)to;
        
        CGFloat v0_r, v0_g, v0_b, v0_a;
        if ([v0 getRed:&v0_r green:&v0_g blue:&v0_b alpha:&v0_a]) {
            self.v0 = [NSMutableArray arrayWithObjects:
                       @(v0_r), @(v0_g), @(v0_b), @(v0_a),
                       nil];
        }
        CGFloat v1_r, v1_g, v1_b, v1_a;
        if ([v1 getRed:&v1_r green:&v1_g blue:&v1_b alpha:&v1_a]) {
            self.v1 = [NSMutableArray arrayWithObjects:
                       @(v1_r), @(v1_g), @(v1_b), @(v1_a),
                       nil];
        }
        
    }
}

- (id)recoveryToValue {
    
    if (self.typeBit == 0x1) { //CGRect
        return [NSValue valueWithCGRect:(CGRect){
            [self.v0[0] doubleValue],
            [self.v0[1] doubleValue],
            [self.v0[2] doubleValue],
            [self.v0[3] doubleValue]
        }];
    }
    if (self.typeBit == 0x10) { //CGSize
        return [NSValue valueWithCGSize:(CGSize){
            [self.v0[0] doubleValue],
            [self.v0[1] doubleValue]
        }];
    }
    if (self.typeBit == 0x100) { //CGPoint
        return [NSValue valueWithCGPoint:(CGPoint){
            [self.v0[0] doubleValue],
            [self.v0[1] doubleValue]
        }];
    }
    if (self.typeBit == 0x1000) { //CGVector
        return [NSValue valueWithCGVector:(CGVector){
            [self.v0[0] doubleValue],
            [self.v0[1] doubleValue]
        }];
    }
    if (self.typeBit == 0x10000) { //CGFloat
        return self.v0[0];
    }
    if (self.typeBit == 0x100000) { //UIOffset
        return [NSValue valueWithUIOffset:(UIOffset){
            [self.v0[0] doubleValue],
            [self.v0[1] doubleValue]
        }];
    }
    if (self.typeBit == 0x1000000) { //CATransform3D
        return [NSValue valueWithCATransform3D:(CATransform3D){
            [self.v0[0] doubleValue], [self.v0[1] doubleValue], [self.v0[2] doubleValue], [self.v0[3] doubleValue],
            [self.v0[4] doubleValue], [self.v0[5] doubleValue], [self.v0[6] doubleValue], [self.v0[7] doubleValue],
            [self.v0[8] doubleValue], [self.v0[9] doubleValue], [self.v0[10] doubleValue], [self.v0[11] doubleValue],
            [self.v0[12] doubleValue], [self.v0[13] doubleValue], [self.v0[14] doubleValue], [self.v0[15] doubleValue]
        }];
    }
    if (self.typeBit == 0x10000000) { //CGAffineTransform
        return [NSValue valueWithCGAffineTransform:(CGAffineTransform){
            [self.v0[0] doubleValue], [self.v0[1] doubleValue], [self.v0[2] doubleValue], [self.v0[3] doubleValue],
            [self.v0[4] doubleValue], [self.v0[5] doubleValue]
        }];
    }
    if (self.typeBit == 0x100000000) { //UIColor
        CGFloat r = [self.v0[0] doubleValue];
        CGFloat g = [self.v0[1] doubleValue];
        CGFloat b = [self.v0[2] doubleValue];
        CGFloat a = MIN(1, MAX([self.v0[3] doubleValue], 0));
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

- (BOOL)didMoveToEnd {
    if (self.v0.count != self.v1.count) {
        return NO;
    }
    NSMutableArray<NSNumber *> *v0 = self.v0;
    NSMutableArray<NSNumber *> *v1 = self.v1;
    __block BOOL isEqual = YES;
    [v0 enumerateObjectsUsingBlock:^(NSNumber * _Nonnull vi0,
                                     NSUInteger idx,
                                     BOOL * _Nonnull stop) {
        NSNumber *vi1 = v1[idx];
        if (![vi0 isEqualToNumber:vi1]) {
            isEqual = NO;
            *stop = YES;
        }
    }];
    return isEqual;
}

- (void)moveToNextWithT:(CGFloat)t d:(CGFloat)d {
    if (self.v0.count != self.v1.count) {
        return;
    }
    XHBTweenEasingFunction easingFunction = self.easing.function;
    if (easingFunction) {
        NSMutableArray<NSNumber *> *v0 = self.v0;
        NSMutableArray<NSNumber *> *v1 = self.v1;
        [v1 enumerateObjectsUsingBlock:^(NSNumber * _Nonnull vi1,
                                         NSUInteger idx,
                                         BOOL * _Nonnull stop) {
            NSNumber *vi0 = v0[idx];
            CGFloat vic0 = [vi0 doubleValue];
            CGFloat vic1 = [vi1 doubleValue];
            //当前变化是否为正向
            BOOL direction = vic1 > vic0;
            if (vic0 == vic1) { return; }
            CGFloat b = easingFunction(t, vic0, vic1 - vic0, d);
            v0[idx] = @(direction ? MAX(b, vic0) : MAX(b, vic1));
        }];
        
    }
}

@end

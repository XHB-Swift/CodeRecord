//
//  XHBBezierPathBubbleTipsView.m
//  WorkFragment
//
//  Created by 谢鸿标 on 2022/6/9.
//

#import "XHBBezierPathBubbleTipsView.h"
#import "XHBUIKitHeaders.h"

@interface XHBBezierPathBubbleTipsView ()

@property (nonatomic, strong) UIView *bubbleView;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) CAShapeLayer *bubbleLayer;
@property (nonatomic, assign) CGPoint arrowPoint;

@end

@implementation XHBBezierPathBubbleTipsView

+ (instancetype)bubbleTipsWithCustomView:(UIView *)customView {
    
    XHBBezierPathBubbleTipsView *tipsView = [[XHBBezierPathBubbleTipsView alloc] initWithFrame:(CGRectZero)];
    [tipsView.bubbleView addSubview:customView];
    tipsView.customView = customView;
    return tipsView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bubbleView];
    }
    
    return self;
}

#pragma mark - Event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchedPoint = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.bubbleView.frame, touchedPoint)) {
        return;
    }
    [self removeFromSuperview];
}

#pragma mark - Public

- (void)setArrowSize:(CGSize)arrowSize {
    if (CGSizeEqualToSize(_arrowSize, arrowSize)) {
        return;
    }
    _arrowSize = arrowSize;
}

- (void)setArrowOffset:(CGFloat)arrowOffset {
    if (_arrowOffset == arrowOffset) {
        return;
    }
    _arrowOffset = arrowOffset;
}

- (void)setBubbleColor:(UIColor *)bubbleColor {
    _bubbleColor = bubbleColor;
    self.bubbleLayer.fillColor = [bubbleColor CGColor];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius == cornerRadius) {
        return;
    }
    _cornerRadius = cornerRadius;
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(_contentInsets, contentInsets)) {
        return;
    }
    _contentInsets = contentInsets;
}

- (void)setBubblePosition:(CGPoint)bubblePosition {
    if (CGPointEqualToPoint(_bubblePosition, bubblePosition)) {
        return;
    }
    _bubblePosition = bubblePosition;
    self.bubbleView.origin = bubblePosition;
}

- (void)setArrowPosition:(XHBBezierPathBubbleTipsViewArrowPosition)arrowPosition {
    if (_arrowPosition == arrowPosition) {
        return;
    }
    _arrowPosition = arrowPosition;
}

- (void)setArrowDirection:(XHBBezierPathBubbleTipsViewArrowDirection)arrowDirection {
    if (_arrowDirection == arrowDirection) {
        return;
    }
    _arrowDirection = arrowDirection;
}

- (void)updateLayout {
    BOOL isUp = self.arrowDirection == XHBBezierPathBubbleTipsViewArrowDirectionUp;
    BOOL isDown = self.arrowDirection == XHBBezierPathBubbleTipsViewArrowDirectionDown;
    BOOL isLeft = self.arrowDirection == XHBBezierPathBubbleTipsViewArrowDirectionLeft;
    BOOL isVertical = (isUp || isDown);
    self.bubbleView.width = self.contentInsets.left + self.contentInsets.right + self.customView.width + (isVertical ? 0 : self.arrowSize.width);
    self.bubbleView.height = self.contentInsets.top + self.contentInsets.bottom + self.customView.height + (isVertical ? self.arrowSize.height : 0);
    if (isVertical) {
        
        if (isUp) {
            self.customView.origin = (CGPoint){self.contentInsets.left, self.contentInsets.top + self.arrowSize.height};
        } else {
            self.customView.origin = (CGPoint){self.contentInsets.left, self.contentInsets.bottom};
        }
        
    } else {
        
        if (isLeft) {
            self.customView.origin = (CGPoint){self.contentInsets.left + self.arrowSize.width, self.contentInsets.top};
        } else {
            self.customView.origin = (CGPoint){self.contentInsets.left, self.contentInsets.top};
        }
        
    }
    [self updateArrowPoint];
    [self updateBubbleShape];
}

#pragma mark - Private

- (void)updateArrowPoint {
    BOOL isUp = self.arrowDirection == XHBBezierPathBubbleTipsViewArrowDirectionUp;
    BOOL isDown = self.arrowDirection == XHBBezierPathBubbleTipsViewArrowDirectionDown;
    BOOL isLeft = self.arrowDirection == XHBBezierPathBubbleTipsViewArrowDirectionLeft;
    BOOL isVertical = (isUp || isDown);
    CGPoint arrowPoint = self.arrowPoint;
    switch (self.arrowPosition) {
        case XHBBezierPathBubbleTipsViewArrowPositionLeading:
        {
            if (isVertical) {
                arrowPoint.x = self.arrowOffset;
                arrowPoint.y = 0;
            } else {
                arrowPoint.x = 0;
                arrowPoint.y = self.arrowOffset;
            }
            break;
        }
        case XHBBezierPathBubbleTipsViewArrowPositionCenter:
        {
            if (isVertical) {
                arrowPoint.x = self.bubbleView.width / 2 - self.arrowSize.width;
                arrowPoint.y = isUp ? 0 : self.bubbleView.height;
            } else {
                arrowPoint.x = isLeft ? 0 : self.bubbleView.width;
                arrowPoint.y = self.bubbleView.height / 2 - self.arrowSize.height;
            }
            break;
        }
        case XHBBezierPathBubbleTipsViewArrowPositionTrailing:
        {
            if (isVertical) {
                arrowPoint.x = self.bubbleView.width - self.arrowOffset - self.arrowSize.width;
                arrowPoint.y = 0;
            } else {
                arrowPoint.x = 0;
                arrowPoint.y = self.bubbleView.height - self.arrowOffset - self.arrowSize.height;
            }
            break;
        }
    }
    
    self.arrowPoint = arrowPoint;
}

- (void)updateBubbleShape {
    
    CGFloat arrowX = self.arrowPoint.x;
    CGFloat arrowY = self.arrowPoint.y;
    CGFloat arrowWidth = self.arrowSize.width;
    CGFloat arrowHeight = self.arrowSize.height;
    CGFloat bubbleWidth = self.bubbleView.width;
    CGFloat bubbleHeight = self.bubbleView.height;
    UIBezierPath *bubblePath = [UIBezierPath bezierPath];
    switch (self.arrowDirection) {
        case XHBBezierPathBubbleTipsViewArrowDirectionUp:
        {
            [bubblePath moveToPoint:(CGPoint){0,arrowY + arrowHeight}];
            [bubblePath addArcWithCenter:(CGPoint){
                self.cornerRadius,
                self.cornerRadius + arrowHeight
            }
                                  radius:self.cornerRadius
                              startAngle:-M_PI
                                endAngle:-M_PI_2
                               clockwise:YES];
            [bubblePath addLineToPoint:(CGPoint){arrowX,arrowY + arrowHeight}];
            [bubblePath addLineToPoint:(CGPoint){arrowX + arrowWidth / 2,0}];
            [bubblePath addLineToPoint:(CGPoint){arrowX + arrowWidth,arrowY + arrowHeight}];
            [bubblePath addLineToPoint:(CGPoint){bubbleWidth,arrowY + arrowHeight}];
            [bubblePath addArcWithCenter:(CGPoint){
                bubbleWidth - self.cornerRadius,
                self.cornerRadius + arrowHeight
            }
                                  radius:self.cornerRadius
                              startAngle:-M_PI_2
                                endAngle:0
                               clockwise:YES];
            [bubblePath addLineToPoint:(CGPoint){bubbleWidth,bubbleHeight}];
            [bubblePath addArcWithCenter:(CGPoint){
                bubbleWidth - self.cornerRadius,
                bubbleHeight - self.cornerRadius
            }
                                  radius:self.cornerRadius
                              startAngle:0
                                endAngle:M_PI_2
                               clockwise:YES];
            [bubblePath addLineToPoint:(CGPoint){0,bubbleHeight}];
            [bubblePath addArcWithCenter:(CGPoint){
                self.cornerRadius,
                bubbleHeight - self.cornerRadius
            }
                                  radius:self.cornerRadius
                              startAngle:M_PI_2
                                endAngle:M_PI
                               clockwise:YES];
            [bubblePath addLineToPoint:(CGPoint){0,arrowHeight}];
            break;
        }
        case XHBBezierPathBubbleTipsViewArrowDirectionDown:
        {
            [bubblePath moveToPoint:(CGPoint){0,0}];
            [bubblePath addArcWithCenter:(CGPoint){
                self.cornerRadius,
                self.cornerRadius
            }
                                  radius:self.cornerRadius
                              startAngle:-M_PI
                                endAngle:-M_PI_2
                               clockwise:YES];
            [bubblePath addLineToPoint:(CGPoint){bubbleWidth,0}];
            [bubblePath addArcWithCenter:(CGPoint){
                bubbleWidth - self.cornerRadius,
                self.cornerRadius
            }
                                  radius:self.cornerRadius
                              startAngle:-M_PI_2
                                endAngle:0
                               clockwise:YES];
            [bubblePath addLineToPoint:(CGPoint){bubbleWidth,bubbleHeight}];
            [bubblePath addArcWithCenter:(CGPoint){
                bubbleWidth - self.cornerRadius,
                bubbleHeight - arrowHeight - self.cornerRadius
            }
                                  radius:self.cornerRadius
                              startAngle:0
                                endAngle:M_PI_2
                               clockwise:YES];
            [bubblePath addLineToPoint:(CGPoint){arrowX + arrowWidth,bubbleHeight - arrowHeight}];
            [bubblePath addLineToPoint:(CGPoint){arrowX + arrowWidth / 2,bubbleHeight}];
            [bubblePath addLineToPoint:(CGPoint){arrowX,bubbleHeight - arrowHeight}];
            [bubblePath addLineToPoint:(CGPoint){0,bubbleHeight - arrowHeight}];
            [bubblePath addArcWithCenter:(CGPoint){
                self.cornerRadius,
                bubbleHeight - arrowHeight - self.cornerRadius
            }
                                  radius:self.cornerRadius
                              startAngle:M_PI_2
                                endAngle:M_PI
                               clockwise:YES];
            [bubblePath addLineToPoint:(CGPoint){0,bubbleHeight - arrowHeight}];
            break;
        }
        case XHBBezierPathBubbleTipsViewArrowDirectionLeft:
        {
            [bubblePath moveToPoint:(CGPoint){arrowHeight,0}];
            [bubblePath addArcWithCenter:(CGPoint){
                self.cornerRadius + arrowHeight,
                self.cornerRadius
            }
                                  radius:self.cornerRadius
                              startAngle:-M_PI
                                endAngle:-M_PI_2
                               clockwise:YES];
            [bubblePath addLineToPoint:(CGPoint){bubbleWidth,0}];
            [bubblePath addArcWithCenter:(CGPoint){
                bubbleWidth - self.cornerRadius,
                self.cornerRadius
            }
                                  radius:self.cornerRadius
                              startAngle:-M_PI_2
                                endAngle:0
                               clockwise:YES];
            [bubblePath addLineToPoint:(CGPoint){bubbleWidth,bubbleHeight}];
            [bubblePath addArcWithCenter:(CGPoint){
                bubbleWidth - self.cornerRadius,
                bubbleHeight - self.cornerRadius
            }
                                  radius:self.cornerRadius
                              startAngle:0
                                endAngle:M_PI_2
                               clockwise:YES];
            [bubblePath addLineToPoint:(CGPoint){arrowHeight,bubbleHeight}];
            [bubblePath addArcWithCenter:(CGPoint){
                arrowHeight + self.cornerRadius,
                bubbleHeight - self.cornerRadius
            }
                                  radius:self.cornerRadius
                              startAngle:M_PI_2
                                endAngle:M_PI
                               clockwise:YES];
            [bubblePath addLineToPoint:(CGPoint){arrowX + arrowHeight,arrowY + arrowWidth}];
            [bubblePath addLineToPoint:(CGPoint){arrowX,arrowY + arrowWidth / 2}];
            [bubblePath addLineToPoint:(CGPoint){arrowX + arrowHeight,arrowY}];
            [bubblePath addLineToPoint:(CGPoint){arrowHeight,0}];
            break;
        }
        case XHBBezierPathBubbleTipsViewArrowDirectionRight:
        {
            [bubblePath moveToPoint:(CGPoint){0,0}];
            [bubblePath addArcWithCenter:(CGPoint){
                self.cornerRadius,
                self.cornerRadius
            }
                                  radius:self.cornerRadius
                              startAngle:-M_PI
                                endAngle:-M_PI_2
                               clockwise:YES];
            [bubblePath addLineToPoint:(CGPoint){bubbleWidth - arrowHeight,0}];
            [bubblePath addArcWithCenter:(CGPoint){
                bubbleWidth - arrowHeight - self.cornerRadius,
                self.cornerRadius
            }
                                  radius:self.cornerRadius
                              startAngle:-M_PI_2
                                endAngle:0
                               clockwise:YES];
            [bubblePath addLineToPoint:(CGPoint){bubbleWidth - arrowHeight,arrowY}];
            [bubblePath addLineToPoint:(CGPoint){bubbleWidth,arrowY + arrowWidth / 2}];
            [bubblePath addLineToPoint:(CGPoint){bubbleWidth - arrowHeight,arrowY + arrowWidth}];
            [bubblePath addLineToPoint:(CGPoint){bubbleWidth - arrowHeight,arrowWidth}];
            [bubblePath addArcWithCenter:(CGPoint){
                bubbleWidth - arrowHeight - self.cornerRadius,
                bubbleHeight - self.cornerRadius
            }
                                  radius:self.cornerRadius
                              startAngle:0
                                endAngle:M_PI_2
                               clockwise:YES];
            [bubblePath addLineToPoint:(CGPoint){0,bubbleHeight}];
            [bubblePath addArcWithCenter:(CGPoint){
                self.cornerRadius,
                bubbleHeight - self.cornerRadius
            }
                                  radius:self.cornerRadius
                              startAngle:M_PI_2
                                endAngle:M_PI
                               clockwise:YES];
            [bubblePath addLineToPoint:(CGPoint){0,0}];
            break;
        }
    }
    
    self.bubbleLayer.path = [bubblePath CGPath];
}

#pragma mark - Getter

- (UIView *)bubbleView {
    
    if (!_bubbleView) {
        _bubbleView = [[UIView alloc] init];
        [_bubbleView.layer addSublayer:self.bubbleLayer];
    }
    
    return _bubbleView;
}

- (CAShapeLayer *)bubbleLayer {
    
    if (!_bubbleLayer) {
        _bubbleLayer = [CAShapeLayer layer];
    }
    
    return _bubbleLayer;
}

@end

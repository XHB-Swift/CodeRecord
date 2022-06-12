//
//  XHBBezierPathBubbleTipsView.h
//  WorkFragment
//
//  Created by 谢鸿标 on 2022/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XHBBezierPathBubbleTipsViewArrowPosition) {
    XHBBezierPathBubbleTipsViewArrowPositionLeading,
    XHBBezierPathBubbleTipsViewArrowPositionCenter,
    XHBBezierPathBubbleTipsViewArrowPositionTrailing
};

typedef NS_ENUM(NSInteger, XHBBezierPathBubbleTipsViewArrowDirection) {
    XHBBezierPathBubbleTipsViewArrowDirectionUp,
    XHBBezierPathBubbleTipsViewArrowDirectionDown,
    XHBBezierPathBubbleTipsViewArrowDirectionLeft,
    XHBBezierPathBubbleTipsViewArrowDirectionRight
};

@interface XHBBezierPathBubbleTipsView : UIView

@property (nonatomic, assign) CGSize arrowSize;
@property (nonatomic, assign) CGFloat arrowOffset;
@property (nonatomic, strong) UIColor *bubbleColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) CGPoint bubblePosition;
@property (nonatomic, assign) XHBBezierPathBubbleTipsViewArrowPosition arrowPosition;
@property (nonatomic, assign) XHBBezierPathBubbleTipsViewArrowDirection arrowDirection;

+ (instancetype)bubbleTipsWithCustomView:(UIView *)customView;

- (void)updateLayout;

@end

NS_ASSUME_NONNULL_END

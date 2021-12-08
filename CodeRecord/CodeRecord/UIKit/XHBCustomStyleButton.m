//
//  XHBCustomStyleButton.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/12/9.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "XHBCustomStyleButton.h"
#import "XHBUIKitHeaders.h"

@interface XHBCustomStyleButton ()

@property (nonatomic, assign) XHBCustomStyleButtonType type;

@end

@implementation XHBCustomStyleButton

+ (instancetype)customStyleButtonWithType:(XHBCustomStyleButtonType)type {
    XHBCustomStyleButton *button = [XHBCustomStyleButton buttonWithType:(UIButtonTypeCustom)];
    button.type = type;
    button.spacing = 10;
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    [self styleLayoutImageTextView];
}

- (void)styleLayoutImageTextView {
    BOOL isVerticalLayout = (self.type == XHBCustomStyleButtonTypeTopImageBottomText ||
                             self.type == XHBCustomStyleButtonTypeTopImageBottomText);
    if (isVerticalLayout) {
        self.height += self.spacing;
    }else {
        self.width += self.spacing;
    }
    CGPoint center = (CGPoint){self.width / 2, self.height / 2};
    if (isVerticalLayout) {
        self.imageView.centerX = center.x;
        self.titleLabel.centerX = center.x;
        if (self.type == XHBCustomStyleButtonTypeTopImageBottomText) {
            self.titleLabel.y = self.imageView.bottom + self.spacing;
        }else {
            self.imageView.y = self.titleLabel.bottom + self.spacing;
        }
    }else {
        self.imageView.centerY = center.y;
        self.titleLabel.centerY = center.y;
        if (self.type == XHBCustomStyleButtonTypeLeftImageRightText) {
            self.titleLabel.x = self.imageView.right + self.spacing;
        }else {
            self.imageView.x = self.titleLabel.right + self.spacing;
        }
    }
}

@end

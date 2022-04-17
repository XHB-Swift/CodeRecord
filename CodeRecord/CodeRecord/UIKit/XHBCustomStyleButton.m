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
    BOOL isTopText = self.type == XHBCustomStyleButtonTypeTopImageBottomText;
    BOOL isTopImage = self.type == XHBCustomStyleButtonTypeTopImageBottomText;
    BOOL isLeftText = self.type == XHBCustomStyleButtonTypeLeftTextRightImage;
    BOOL isLeftImage = self.type == XHBCustomStyleButtonTypeLeftImageRightText;
    
    BOOL isVerticalLayout = (isTopText || isTopImage);
    BOOL isHorizontalLayout = (isLeftText || isLeftImage);
    
    CGFloat x = 0, y = 0;
    
    if (isVerticalLayout) {
        
        CGFloat height = self.imageView.height + self.titleLabel.height + self.spacing;
        if (height > self.height) {
            self.height = height;
        } else {
            y = (self.height - height) / 2;
        }
        CGFloat width = MAX(self.titleLabel.width, self.imageView.width);
        if (width > self.width) {
            self.width = width;
        } else {
            x = (self.width - width) / 2;
        }
        if (isTopText) {
            self.titleLabel.origin = (CGPoint){x,y};
            self.imageView.y = self.titleLabel.bottom + self.spacing;
            self.imageView.centerX = self.width / 2;
        } else if (isTopImage) {
            self.imageView.origin = (CGPoint){x,y};
            self.titleLabel.y = self.imageView.bottom + self.spacing;
            self.titleLabel.centerX = self.width / 2;
        }
        
    } else if (isHorizontalLayout) {
        
        CGFloat width = self.imageView.width + self.titleLabel.width + self.spacing;
        if (width > self.width) {
            self.width = width;
        } else {
            x = (self.width - width) / 2;
        }
        CGFloat height = MAX(self.imageView.height, self.titleLabel.height);
        if (height > self.height) {
            self.height = height;
        } else {
            y = (self.height - height) / 2;
        }
        if (isLeftText) {
            self.titleLabel.origin = (CGPoint){x,y};
            self.imageView.x = self.titleLabel.right + self.spacing;
            self.imageView.centerY = self.height / 2;
        } else if (isLeftImage) {
            self.imageView.origin = (CGPoint){x,y};
            self.titleLabel.x = self.imageView.right + self.spacing;
            self.titleLabel.centerY = self.height / 2;
        }
    }
}

@end

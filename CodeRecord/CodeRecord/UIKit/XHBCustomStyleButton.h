//
//  XHBCustomStyleButton.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/12/9.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 按钮图文布局
 * XHBCustomStyleButtonTypeTopImageBottomText 上图下文
 * XHBCustomStyleButtonTypeTopTextBottomImage 上文下图
 * XHBCustomStyleButtonTypeLeftImageRightText 左图右文
 * XHBCustomStyleButtonTypeLeftTextRightImage 左文右图
 **/
typedef NS_ENUM(NSInteger, XHBCustomStyleButtonType) {
    
    XHBCustomStyleButtonTypeTopImageBottomText,
    XHBCustomStyleButtonTypeTopTextBottomImage,
    XHBCustomStyleButtonTypeLeftImageRightText,
    XHBCustomStyleButtonTypeLeftTextRightImage,
};

@interface XHBCustomStyleButton : UIButton

//默认10
@property (nonatomic, assign) CGFloat spacing;

+ (instancetype)customStyleButtonWithType:(XHBCustomStyleButtonType)type;

@end

NS_ASSUME_NONNULL_END

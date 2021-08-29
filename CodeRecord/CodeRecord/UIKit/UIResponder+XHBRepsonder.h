//
//  UIResponder+XHBRepsonder.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (XHBRepsonder)

- (void)respondsValue:(nullable id)value fromEvent:(NSString *)event sender:(UIResponder *)sender;

@end

NS_ASSUME_NONNULL_END

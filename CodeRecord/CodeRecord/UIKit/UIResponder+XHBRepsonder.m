//
//  UIResponder+XHBRepsonder.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2021/8/21.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "UIResponder+XHBRepsonder.h"

@implementation UIResponder (XHBRepsonder)

- (void)respondsValue:(nullable id)value fromEvent:(NSString *)event sender:(UIResponder *)sender {
    [self.nextResponder respondsValue:value fromEvent:event sender:sender];
}

@end

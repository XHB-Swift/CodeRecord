//
//  UIView+XHBLevelWeight.h
//  CodeRecord
//
//  Created by xiehongbiao on 2022/1/12.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XHBLevelWeight)

@property (nonatomic, readonly, strong, nullable) NSNumber *levelWeight;

- (void)addSubview:(UIView *)view levelWeight:(NSInteger)levelWeight;

@end

NS_ASSUME_NONNULL_END

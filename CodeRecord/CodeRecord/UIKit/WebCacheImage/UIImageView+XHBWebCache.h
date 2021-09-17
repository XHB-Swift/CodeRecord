//
//  UIImageView+XHBWebCache.h
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/17.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (XHBWebCache)

- (void)setImageWithURL:(id<XHBURLType>)url;

@end

NS_ASSUME_NONNULL_END

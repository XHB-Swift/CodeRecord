//
//  UIImageView+XHBWebCache.m
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/17.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "UIImageView+XHBWebCache.h"

@implementation UIImageView (XHBWebCache)

- (void)setImageWithURL:(id<XHBURLType>)url {
    
    __weak typeof(self) weakSelf = self;
    [UIImage fetchImageWithURL:url
                    completion:^(UIImage *_Nullable image,
                                 NSError *_Nullable error) {
        if (image) {
            weakSelf.image = image;
        }else {
            NSLog(@"error = %@", error);
        }
    }];
}

@end

//
//  UIImage+XHBWebCache.h
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/17.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XHBWebCacheCompletion)(UIImage *_Nullable image, NSError *_Nullable error);

@protocol XHBURLType <NSObject>

@required

- (nullable NSURL *)url;

@end

@interface NSURL (XHBWebCache) <XHBURLType>
@end

@interface NSString (XHBWebCache) <XHBURLType>
@end

@interface UIImage (XHBWebCache)

+ (void)fetchImageWithURL:(id<XHBURLType>)url completion:(XHBWebCacheCompletion)completion;

@end

NS_ASSUME_NONNULL_END

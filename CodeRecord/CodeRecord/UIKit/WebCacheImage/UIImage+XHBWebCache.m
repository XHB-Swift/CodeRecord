//
//  UIImage+XHBWebCache.m
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/17.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "UIImage+XHBWebCache.h"
#import "NSObject+XHBFileDownloader.h"

@implementation NSURL (XHBWebCache)

- (NSURL *)url {
    return self;
}

@end

@implementation NSString (XHBWebCache)

- (NSURL *)url {
    return [self hasPrefix:@"file://"] ? [NSURL fileURLWithPath:self] : [NSURL URLWithString:self];
}

@end

@implementation UIImage (XHBWebCache)

+ (void)fetchImageWithURL:(id<XHBURLType>)url completion:(XHBWebCacheCompletion)completion {
    XHBWebCacheCompletion mainBlock = ^(UIImage *_Nullable image, NSError *_Nullable error) {
        if ([NSThread isMainThread]) {
            if (completion) {
                completion(image, error);
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(image, error);
                }
            });
        }
    };
    NSString *urlString = [url isKindOfClass:[NSString class]] ? (NSString *)url : [[url url] relativePath];
    [self fetchFileWithUrl:urlString
                completion:^(BOOL isDownload,
                             NSURL * _Nullable cachedFileUrl,
                             NSError * _Nullable error) {
        if (error) {
            mainBlock(nil, error);
        } else {
            UIImage *image = [[UIImage imageWithContentsOfFile:cachedFileUrl.relativePath] decodedImage];
            mainBlock(image, nil);
        }
    }];
}

@end

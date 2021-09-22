//
//  UIImage+XHBWebCache.m
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/17.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import "UIImage+XHBWebCache.h"

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
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(image, error);
                }
            });
        }
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![url respondsToSelector:@selector(url)]) {
            mainBlock(nil, NSErrorMarkFunc(8,@"No url"));
            return;
        }
        NSURL *url0 = [url url];
        if (!url0) {
            mainBlock(nil, NSErrorMarkFunc(8,@"No [url url]"));
            return;
        }
        NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        if (!cacheDir) {
            mainBlock(nil, NSErrorMarkFunc(9, @"No cacheDir"));
            return;
        }
        cacheDir = [cacheDir stringByAppendingPathComponent:@"UIImageWebCacheDir"];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if (![fileMgr fileExistsAtPath:cacheDir]) {
            NSError *error = nil;
            [fileMgr createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                mainBlock(nil, error);
                return;
            }
        }
        if (url0.isFileURL) {
            UIImage *image = [[UIImage imageWithContentsOfFile:url0.absoluteString] decodedImage];
            if (image) {
                mainBlock(image,nil);
            }else {
                NSString *errorMsg = [NSString stringWithFormat:@"load local image failed, url = %@", url];
                mainBlock(nil, NSErrorMarkFunc(10, errorMsg));
            }
            return;
        }else {
            NSString *filePath = [cacheDir stringByAppendingPathComponent:url0.absoluteString.md5String];
            if ([fileMgr fileExistsAtPath:filePath]) {
                UIImage *image = [UIImage imageWithContentsOfFile:filePath];
                if (image) {
                    mainBlock(image, nil);
                    return;
                }
            }
            [self downloadImageWithURL:url0
                         cachedFileURL:[NSURL fileURLWithPath:filePath]
                            completion:mainBlock];
        }
    });
}


+ (void)downloadImageWithURL:(NSURL *)url cachedFileURL:(NSURL *)cachedFileURL completion:(XHBWebCacheCompletion)completion {
    XHBWebCacheCompletion handleBlock = ^(UIImage *_Nullable image, NSError *_Nullable error) {
        if (completion) {
            completion(image,error);
        }
    };
    
    if (![url isKindOfClass:[NSURL class]]) {
        handleBlock(nil, NSErrorMarkFunc(NSURLErrorBadURL, @"maybeURL is nil"));
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [[[NSURLSession sharedSession] downloadTaskWithRequest:request
                                         completionHandler:^(NSURL * _Nullable location,
                                                             NSURLResponse * _Nullable response,
                                                             NSError * _Nullable error) {
        
        
        if (error) {
            handleBlock(nil,error);
        }else {
            static dispatch_semaphore_t lock = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                lock = dispatch_semaphore_create(1);
            });
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            if ([response respondsToSelector:@selector(statusCode)] &&
                [location isKindOfClass:[NSURL class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode == 200) {
                    
                    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
                    NSError *fileError = nil;
                    if ([fileMgr fileExistsAtPath:cachedFileURL.path]) {
                        [fileMgr removeItemAtURL:cachedFileURL error:&fileError];
                    }
                    if (fileError) {
                        dispatch_semaphore_signal(lock);
                        handleBlock(nil, fileError);
                        return;
                    }
                    [fileMgr moveItemAtURL:location toURL:cachedFileURL error:&fileError];
                    dispatch_semaphore_signal(lock);
                    UIImage *image = [[UIImage imageWithContentsOfFile:cachedFileURL.path] decodedImage];
                    if (image) {
                        handleBlock(image, nil);
                    }else {
                        handleBlock(nil, NSErrorMarkFunc(NSURLErrorCannotOpenFile, @"image is nil"));
                    }
                    
                }else {
                    handleBlock(nil, NSErrorMarkFunc(NSURLErrorResourceUnavailable, @"response error"));
                }
                
            }else {
                handleBlock(nil, NSErrorMarkFunc(NSURLErrorCannotParseResponse, @"not http response"));
            }
        }
        
    }] resume];
}

@end

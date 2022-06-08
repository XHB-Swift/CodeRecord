//
//  NSObject+XHBFileDownloader.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2022/5/26.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import "NSObject+XHBFileDownloader.h"

#define XHBFunctionDomain [NSString stringWithFormat:@"%s",__func__]
#define XHBDownloaderError(code,desc) NSErrorMake(XHBFunctionDomain, (code), (desc))

@implementation NSObject (XHBFileDownloader)

+ (void)fetchFileWithUrl:(NSString *)url {
    [self fetchFileWithUrl:url format:nil];
}

+ (void)fetchFileWithUrl:(NSString *)url
              completion:(nullable XHBFileDownloaderCompletion)completion {
    [self fetchFileWithUrl:url format:nil completion:completion];
}

+ (void)fetchFileWithUrl:(NSString *)url
                  format:(NSString *)format {
    [self fetchFileWithUrl:url format:format completion:nil];
}

+ (void)fetchFileWithUrl:(NSString *)url
                  format:(NSString *)format
              completion:(nullable XHBFileDownloaderCompletion)completion {
    [self fetchFileWithUrl:url
                    format:format
           documentDirPath:nil
                   dirName:nil
                completion:completion];
}

+ (void)fetchFileWithUrl:(NSString *)url
                  format:(NSString *)format
         documentDirPath:(nullable NSString *)documentDirPath
              completion:(nullable XHBFileDownloaderCompletion)completion {
    [self fetchFileWithUrl:url
                    format:format
           documentDirPath:documentDirPath
                   dirName:nil
                completion:completion];
}

+ (void)fetchFileWithUrl:(NSString *)url
                  format:(NSString *)format
                 dirName:(nullable NSString *)dirName
              completion:(nullable XHBFileDownloaderCompletion)completion {
    [self fetchFileWithUrl:url
                    format:format
           documentDirPath:nil
                   dirName:dirName
                completion:completion];
}

+ (void)fetchFileWithUrl:(NSString *)url
                  format:(NSString *)format
         documentDirPath:(nullable NSString *)documentDirPath
                 dirName:(nullable NSString *)dirName
              completion:(nullable XHBFileDownloaderCompletion)completion {
    
    XHBFileDownloaderCompletion mainBlock = ^(BOOL isDownload, NSURL *_Nullable cachedFileUrl, NSError *_Nullable error){
        if ([NSThread isMainThread]) {
            if (completion) {
                completion(isDownload, cachedFileUrl, error);
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(isDownload, cachedFileUrl, error);
                }
            });
        }
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![url isKindOfClass:[NSString class]]) {
            mainBlock(NO,nil,XHBDownloaderError(8,@"No url"));
            return;
        }
        BOOL noDocumentPath = (![documentDirPath isKindOfClass:[NSString class]] || documentDirPath.length == 0);
        NSString *cachedFilePath = noDocumentPath ? [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] : documentDirPath;
        if (!cachedFilePath) { return; }
        if ([dirName isKindOfClass:[NSString class]] && dirName.length > 0) {
            cachedFilePath = [cachedFilePath stringByAppendingPathComponent:dirName];
        }
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if (![fileMgr fileExistsAtPath:cachedFilePath]) {
            NSError *error = nil;
            [fileMgr createDirectoryAtPath:cachedFilePath withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                mainBlock(NO,nil,error);
                return;
            }
        }
        NSURL *remoteUrl = [NSURL URLWithString:url];
        if (!remoteUrl) {
            mainBlock(NO,nil,XHBDownloaderError(10, ([NSString stringWithFormat:@"Invaidate url: %@", url])));
            return;
        }
        BOOL hasFormat = ([format isKindOfClass:[NSString class]] && format.length > 0);
        NSString *fileName = remoteUrl.absoluteString.md5String;
        if (hasFormat) {
            fileName = [NSString stringWithFormat:@"%@.%@", fileName, format];
        }
        cachedFilePath = [cachedFilePath stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:cachedFilePath]) {
            mainBlock(NO,[NSURL fileURLWithPath:cachedFilePath],nil);
            return;
        }
        NSURL *filePath = [NSURL fileURLWithPath:cachedFilePath];
        [self downloadFileWithUrl:remoteUrl cachedFileUrl:filePath completion:mainBlock];
    });
}

+ (void)downloadFileWithUrl:(NSURL *)url cachedFileUrl:(NSURL *)cachedFileUrl completion:(XHBFileDownloaderCompletion)completion {
    
    [[[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location,
                                                                               NSURLResponse * _Nullable response,
                                                                               NSError * _Nullable error) {
        
        if (error) {
            completion(YES,nil,error);
        } else {
            static dispatch_semaphore_t lock = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                lock = dispatch_semaphore_create(1);
            });
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (statusCode == 200) {
                dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
                NSError *fileError = nil;
                if ([fileMgr fileExistsAtPath:cachedFileUrl.relativePath]) {
                    [fileMgr removeItemAtURL:cachedFileUrl error:&fileError];
                }
                if (fileError) {
                    completion(YES,nil,fileError);
                    dispatch_semaphore_signal(lock);
                    return;
                }
                [fileMgr moveItemAtURL:location toURL:cachedFileUrl error:&fileError];
                dispatch_semaphore_signal(lock);
                if (fileError) {
                    completion(YES,nil,fileError);
                } else {
                    completion(YES,cachedFileUrl,nil);
                }
            } else {
                completion(YES,nil,XHBDownloaderError(statusCode, @"Wrong HTTP Status code"));
            }
        }
        
    }] resume];
}

+ (void)clearFileWithUrl:(NSString *)url documentDirPath:(NSString *)documentDirPath {
    [self clearFileWithUrl:url documentDirPath:documentDirPath format:nil];
}

+ (void)clearFileWithUrl:(NSString *)url documentDirPath:(NSString *)documentDirPath format:(nullable NSString *)format {
    if (![url isKindOfClass:[NSString class]] || url.length == 0) {
        return;
    }
    if (![documentDirPath isKindOfClass:[NSString class]] || documentDirPath.length == 0) {
        return;
    }
    NSURL *remoteUrl = [NSURL URLWithString:url];
    NSString *fileName = remoteUrl.absoluteString.md5String;
    BOOL hasFormat = ([format isKindOfClass:[NSString class]] && format.length > 0);
    if (hasFormat) {
        fileName = [NSString stringWithFormat:@"%@.%@",fileName, format];
    }
    NSString *filePath = [documentDirPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:filePath]) {
        return;
    }
    NSError *error = nil;
    [fileMgr removeItemAtPath:filePath error:&error];
    if (error) {
        NSLog(@"error = %@", error);
    }
}

@end

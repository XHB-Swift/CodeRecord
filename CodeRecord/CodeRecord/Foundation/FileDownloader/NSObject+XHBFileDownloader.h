//
//  NSObject+XHBFileDownloader.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2022/5/26.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XHBFileDownloaderCompletion)(BOOL isDownload, NSURL *_Nullable cachedFileUrl, NSError *_Nullable error);

@interface NSObject (XHBFileDownloader)

+ (void)fetchFileWithUrl:(NSString *)url;

+ (void)fetchFileWithUrl:(NSString *)url
              completion:(nullable XHBFileDownloaderCompletion)completion;

+ (void)fetchFileWithUrl:(NSString *)url
                  format:(nullable NSString *)format;

+ (void)fetchFileWithUrl:(NSString *)url
                  format:(nullable NSString *)format
              completion:(nullable XHBFileDownloaderCompletion)completion;

+ (void)fetchFileWithUrl:(NSString *)url
                  format:(nullable NSString *)format
         documentDirPath:(nullable NSString *)documentDirPath
              completion:(nullable XHBFileDownloaderCompletion)completion;

+ (void)fetchFileWithUrl:(NSString *)url
                  format:(nullable NSString *)format
                 dirName:(nullable NSString *)dirName
              completion:(nullable XHBFileDownloaderCompletion)completion;

+ (void)fetchFileWithUrl:(NSString *)url
                  format:(nullable NSString *)format
         documentDirPath:(nullable NSString *)documentDirPath
                 dirName:(nullable NSString *)dirName
              completion:(nullable XHBFileDownloaderCompletion)completion;

+ (void)clearFileWithUrl:(NSString *)url documentDirPath:(NSString *)documentDirPath;

+ (void)clearFileWithUrl:(NSString *)url documentDirPath:(NSString *)documentDirPath format:(nullable NSString *)format;

@end

NS_ASSUME_NONNULL_END

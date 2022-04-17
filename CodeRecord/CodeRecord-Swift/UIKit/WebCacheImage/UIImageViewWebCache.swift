//
//  UIImageViewWebCache.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/9/6.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit

private let lock = DispatchSemaphore(value: 1)
private let kBytesPerPixel = 4
private let kBitsPerComponent = 8

public typealias ImageLoadCompletion = (_ result: Result<UIImage, Error>) -> Void

public enum ImageScale {
    case auto
    case scale(s_width: CGFloat, s_height: CGFloat)
}

public struct ThumbnailConfig {
    let pointSize: CGSize
    let scale: ImageScale
    
    public static let noThumbnail = ThumbnailConfig(pointSize: .zero, scale: .auto)
}

public protocol URLType {
    
    var url: URL? { get }
}

extension String: URLType {
    
    public var url: URL? {
        return hasPrefix("file://") ? URL(fileURLWithPath: self) : URL(string: self)
    }
}

extension URL: URLType {
    
    public var url: URL? { return self }
}

extension UIImage {
    
    public convenience init?(url: URLType, to size: CGSize, scale: ImageScale = .auto) {
        guard let realUrl = url.url else { return nil }
        let imageSourceOptions = [kCGImageSourceShouldCache : false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(realUrl as CFURL, imageSourceOptions) else { return nil }
        let maxDimensionInPixels: CGFloat
        switch scale {
        case .auto:
            maxDimensionInPixels = max(size.width, size.height) / (max(size.width, size.height) / min(size.width, size.height))
        case .scale(let s_width, let s_height):
            maxDimensionInPixels = max(size.width, size.height) * (s_width / s_height)
        }
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailWithTransform : true,
            kCGImageSourceShouldCacheImmediately : true,
            kCGImageSourceThumbnailMaxPixelSize : maxDimensionInPixels,
            kCGImageSourceCreateThumbnailFromImageAlways : true,
        ] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return nil }
        self.init(cgImage: downsampledImage)
    }
    
    open var decoded: UIImage? {
        if !shouldDecode {
            return self
        }
        var resultWithoutAplha: UIImage? = nil
        autoreleasepool { [weak self] in
            
            guard let imageRef = self?.cgImage,
                  let colorSpaceRef = imageRef.colorSpace else {
                resultWithoutAplha = self
                return
            }
            let width = imageRef.width
            let height = imageRef.height
            let bytesPerRow = kBytesPerPixel * width
            guard let context = CGContext(data: nil,
                                          width: width,
                                          height: height,
                                          bitsPerComponent: kBitsPerComponent,
                                          bytesPerRow: bytesPerRow,
                                          space: colorSpaceRef,
                                          bitmapInfo: CGImageByteOrderInfo.order32Big.rawValue) else {
                resultWithoutAplha = self
                return
            }
            context.draw(imageRef, in: CGRect(x: 0, y: 0, width: width, height: height))
            guard let decodedImageRef = context.makeImage() else {
                resultWithoutAplha = self
                return
            }
            resultWithoutAplha = UIImage(cgImage: decodedImageRef, scale: scale, orientation: imageOrientation)
        }
        return resultWithoutAplha
    }
    
    open var shouldDecode: Bool {
        if images != nil {
            return false
        }
        
        guard let alphaInfo = cgImage?.alphaInfo else { return true }
        return !(alphaInfo == .first ||
                 alphaInfo == .last ||
                 alphaInfo == .premultipliedFirst ||
                 alphaInfo == .premultipliedLast)
    }
    
    open class func fetchImage(with url: URLType, thumbnail: ThumbnailConfig = .noThumbnail, completion: ImageLoadCompletion? = nil) {
        DispatchQueue.global().async {
            guard let cacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
                DispatchQueue.main.async {
                    completion?(.failure(FoundationError.notFoundDir))
                }
                return
            }
            let docDir = cacheDir.appending("/UIImageWebCacheDir")
            let fileManager = FileManager.default
            let isDirExist = fileManager.fileExists(atPath: docDir, isDirectory: nil)
            if !isDirExist {
                do {
                    try fileManager.createDirectory(atPath: docDir, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    DispatchQueue.main.async {
                        completion?(.failure(error))
                    }
                    return
                }
            }
            guard let url = url.url else {
                DispatchQueue.main.async {
                    completion?(.failure(FoundationError.nilValue))
                }
                return
            }
            if url.isFileURL {
                if thumbnail.pointSize != .zero,
                   let thumbnailImage = UIImage(url: url, to: thumbnail.pointSize, scale: thumbnail.scale)?.decoded {
                    DispatchQueue.main.async {
                        completion?(.success(thumbnailImage))
                    }
                   return
                }
                let result: Result<UIImage, Error>
                if let image = UIImage(contentsOfFile: url.absoluteString)?.decoded {
                    result = .success(image)
                } else {
                    result = .failure(FoundationError.nilValue)
                }
                DispatchQueue.main.async {
                    completion?(result)
                }
            } else {
                let filePath = docDir.appending("/\(url.absoluteString.md5String)")
                let isFileExist = fileManager.fileExists(atPath: filePath, isDirectory: nil)
                if isFileExist {
                    if let thumbnailImage = UIImage(url: URL(fileURLWithPath: filePath), to: thumbnail.pointSize, scale: thumbnail.scale)?.decoded {
                        DispatchQueue.main.async {
                            completion?(.success(thumbnailImage))
                        }
                        return
                    }
                    if let image = UIImage(contentsOfFile: filePath)?.decoded {
                        DispatchQueue.main.async {
                            completion?(.success(image))
                        }
                        return
                    }
                }
                self.downloadImage(with: url, cachedFileUrl: URL(fileURLWithPath: filePath), completion: completion)
            }
        }
    }
    
    private class func downloadImage(with url: URL,
                                     cachedFileUrl: URL,
                                     thumbnail: ThumbnailConfig = .noThumbnail,
                                     completion: ImageLoadCompletion?) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.downloadTask(with: request) { location, response, error in
            let result: Result<UIImage, Error>
            if let happenedError = error {
                result = .failure(happenedError)
            }else {
                lock.wait()
                let fileManager = FileManager.default
                if let httpResponse = response as? HTTPURLResponse,
                   let locationUrl = location,
                   httpResponse.statusCode == 200 {
                    do {
                        if fileManager.fileExists(atPath: cachedFileUrl.path) {
                            try fileManager.removeItem(at: cachedFileUrl)
                        }
                        try fileManager.moveItem(at: locationUrl, to: cachedFileUrl)
                        lock.signal()
                        if let image = UIImage(contentsOfFile: cachedFileUrl.path) {
                            result = .success(image)
                        } else {
                            result = .failure(FoundationError.nilValue)
                        }
                    } catch {
                        lock.signal()
                        result = .failure(error)
                    }
                }else {
                    lock.signal()
                    result = .failure(FoundationError.needToDebugDetails)
                }
            }
            DispatchQueue.main.async {
                completion?(result)
            }
        }.resume()
    }
    
    @available(iOS 13.0, *)
    open class func fetchAsyncImage(with url: URLType, thumbnail: ThumbnailConfig = .noThumbnail) async throws -> UIImage {
        return try await withTaskCancellationHandler(operation: {
            return try await withUnsafeThrowingContinuation({ continuation in
                fetchImage(with: url, thumbnail: thumbnail) { result in
                    switch result {
                    case .success(let img):
                        continuation.resume(returning: img)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            })
        }, onCancel: {
            
        })
    }
}

extension UIImageView {
    
    open func setImage(with url: URLType,
                       thumbnail: ThumbnailConfig = .noThumbnail,
                       completion: ImageLoadCompletion? = nil) {
        if #available(iOS 13, *) {
            Task {
                do {
                    let img = try await UIImage.fetchAsyncImage(with: url, thumbnail: thumbnail)
                    let scale: CGFloat
                    switch thumbnail.scale {
                    case .auto:
                        scale = img.size.width / img.size.height
                    case .scale(let s_width, let s_hegith):
                        scale = s_hegith > 0 ? s_width / s_hegith : 1
                    }
                    self.size = CGSize(width: self.width / scale, height: self.height)
                    self.image = img
                    completion?(.success(img))
                } catch {
                    completion?(.failure(error))
                    print("error = \(error)")
                }
            }
        } else {
            UIImage.fetchImage(with: url, thumbnail: thumbnail) { [weak self] result in
                switch result {
                case .success(let img):
                    let scale: CGFloat
                    switch thumbnail.scale {
                    case .auto:
                        scale = img.size.width / img.size.height
                    case .scale(let s_width, let s_hegith):
                        scale = s_hegith > 0 ? s_width / s_hegith : 1
                    }
                    self?.size = CGSize(width: (self?.width ?? 0) / scale, height: (self?.height ?? 0))
                    self?.image = img
                    break
                case .failure(let error):
                    print("error = \(error)")
                    break
                }
                completion?(result)
            }
        }
    }
}

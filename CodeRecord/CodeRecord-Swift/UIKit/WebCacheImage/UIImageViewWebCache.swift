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

public struct ThumbnailConfig {
    let pointSize: CGSize
    let scale: CGFloat
    
    public static let noThumbnail = ThumbnailConfig(pointSize: .zero, scale: 0)
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
    
    public var url: URL? {
        return self
    }
}

extension UIImage {
    
    public convenience init?(url: URL, to size: CGSize, scale: CGFloat) {
        let imageSourceOptions = [kCGImageSourceShouldCache : false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, imageSourceOptions) else { return nil }
        let maxDimensionInPixels = max(size.width, size.height) * scale
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
                self.completionCallback(.failure(FoundationError.notFoundDir), completion)
                return
            }
            let docDir = cacheDir.appending("/UIImageWebCacheDir")
            let fileManager = FileManager.default
            let isDirExist = fileManager.fileExists(atPath: docDir, isDirectory: nil)
            if !isDirExist {
                do {
                    try fileManager.createDirectory(atPath: docDir, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    self.completionCallback(.failure(error), completion)
                    return
                }
            }
            guard let url = url.url else {
                self.completionCallback(.failure(FoundationError.nilValue), completion)
                return
            }
            if url.isFileURL {
                if thumbnail.pointSize != .zero && thumbnail.scale > 0,
                   let thumbnailImage = UIImage(url: url, to: thumbnail.pointSize, scale: thumbnail.scale)?.decoded {
                    self.completionCallback(.success(thumbnailImage), completion)
                   return
                }
                if let image = UIImage(contentsOfFile: url.absoluteString)?.decoded {
                    self.completionCallback(.success(image), completion)
                }else {
                    self.completionCallback(.failure(FoundationError.nilValue), completion)
                }
                return
            }else {
                let filePath = docDir.appending("/\(url.absoluteString.md5String)")
                let isFileExist = fileManager.fileExists(atPath: filePath, isDirectory: nil)
                if isFileExist {
                    if let thumbnailImage = UIImage(url: URL(fileURLWithPath: filePath), to: thumbnail.pointSize, scale: thumbnail.scale)?.decoded {
                        self.completionCallback(.success(thumbnailImage), completion)
                        return
                    }
                    if let image = UIImage(contentsOfFile: filePath)?.decoded {
                        self.completionCallback(.success(image), completion)
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
            if let happenedError = error {
                self.completionCallback(.failure(happenedError), completion)
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
                            self.completionCallback(.success(image), completion)
                        } else {
                            self.completionCallback(.failure(FoundationError.nilValue), completion)
                        }
                    } catch {
                        lock.signal()
                        self.completionCallback(.failure(error), completion)
                    }
                }else {
                    lock.signal()
                    self.completionCallback(.failure(FoundationError.needToDebugDetails), completion)
                }
            }
        }.resume()
    }
    
    private class func completionCallback(_ result: Result<UIImage, Error>, _ completion: ImageLoadCompletion?) {
        DispatchQueue.main.async {
            completion?(result)
        }
    }
}

extension UIImageView {
    
    open func setImage(with url: URLType,
                       thumbnail: ThumbnailConfig = .noThumbnail,
                       completion: ImageLoadCompletion? = nil) {
        UIImage.fetchImage(with: url, thumbnail: thumbnail) { [weak self] result in
            switch result {
            case .success(let img):
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

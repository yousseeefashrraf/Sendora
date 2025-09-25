//
//  CacheManager.swift
//  Sendora
//
//  Created by Youssef Ashraf on 03/09/2025.
//
import SwiftUI

class CacheManagerServices{
  static let shared = CacheManagerServices()
  let nsCache = NSCacheManagerServices.shared
  private init(){}
  
  
  
  func getProfileImage(forString picString: String) async -> UIImage?{
    let splitedString = picString.split(separator: "/")
    guard !splitedString.isEmpty else {return nil}
    let key = String(splitedString[splitedString.count - 1])
    guard key != "" else {return nil}
    
    if let uiImage = nsCache.get(key: key) {
      return uiImage
    } else if let diskImage = loadImageFromDisk(key: key) {
      nsCache.add(key: key, value: diskImage)
      return diskImage
    } else {
      guard let url = URL(string: picString),
            let image = await NetworkServices.shared.getImageFromInternet(url: url)
      else { return nil }
      
      nsCache.add(key: key, value: image)
      saveImageToDisk(image, key: key)
      return image
    }
  }
  
  func saveImageToDisk(_ image: UIImage, key: String) {
    guard let data = image.pngData() else { return }
    let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(key).jpg")
    try? data.write(to: url)
  }
  
  func loadImageFromDisk(key: String) -> UIImage? {
    let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(key).jpg")
    guard let data = try? Data(contentsOf: url) else { return nil }
    return UIImage(data: data)
  }
  enum cacheError: String, Error{
    case directoryDoesntExist, enableToFetchData, networkError, unknownUser
  }
  
}

class NSCacheManagerServices{
  static let shared = NSCacheManagerServices()
  
  var cache: NSCache<NSString, UIImage> = {
    let cache = NSCache<NSString, UIImage>()
    cache.countLimit = 200
    cache.totalCostLimit = 1024 * 1024 * cache.countLimit
    return cache
  }()
  
  func add(key: String, value: UIImage){
    cache.setObject(value, forKey: key as NSString)
  }
  
  func get(key: String) -> UIImage?{
    return cache.object(forKey: key as NSString)
  }
  
  func isInCache(url: String) -> Bool{
    let splitedString = url.split(separator: "/")
    let key = String(splitedString[splitedString.count - 1])
    return cache.object(forKey: key as NSString) != nil
  }
  
  func isInCache(key: String) -> Bool{
    return cache.object(forKey: key as NSString) != nil
  }
  private init(){}
  
  
}


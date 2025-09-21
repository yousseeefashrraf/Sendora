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
    
    if let uiImage = nsCache.get(key: key){
      return uiImage
    } else {
      
      guard let url = URL(string: picString),  let image = await NetworkServices.shared.getImageFromInternet(url: url) else {return nil}
      
      nsCache.add(key: key, value: image)
      return image
    }
  }
  
  func getDocument<T: Codable>(documentId: String, collection: Collections ) async throws(CacheManagerServices.cacheError) -> T{
    guard let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("\(collection.rawValue)") else {throw .directoryDoesntExist}
    
    if !FileManager.default.fileExists(atPath: directory.path) {
      try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    }
    
    let docPath = directory.appendingPathComponent("\(documentId).json")
    
    if FileManager.default.fileExists(atPath: docPath.path){

      guard let data = try? Data(contentsOf: docPath) else {throw .enableToFetchData}
      guard let document = try? JSONDecoder().decode(T.self, from: data) else {throw .enableToFetchData}
      
      return document
    } else {
      guard let fetchedDoc = try? await DBServicesManager.shared.getDocument(collection: collection, documentId: documentId, documentType: T.self) as? T, let data = try? JSONEncoder().encode(fetchedDoc)  else { throw .unknownUser}
      
      FileManager.default.createFile(atPath: docPath.path, contents: data)
      
      return fetchedDoc
      
    }
  
  }
  
  enum cacheError: String, Error{
    case directoryDoesntExist, enableToFetchData, networkError, unknownUser
  }
  
}

class NSCacheManagerServices{
  static let shared = NSCacheManagerServices()
  
  var cache: NSCache<NSString, UIImage> = {
    let cache = NSCache<NSString, UIImage>()
    cache.countLimit = 100
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


//
//  PhotoToCacheSaver.swift
//  SocialApp
//
//  Created by test on 27.06.2022.
//

import Foundation
import Alamofire

fileprivate protocol DataReloadable {
    
    func reloadRow(atIndexPath IndexPath: IndexPath)
    
}

class PhotoToCacheSaver {
    
    
    private var images = [String: UIImage]()
    
    private let container: DataReloadable
    
    init(container: UITableView) {
        self.container = Table(table: container)
    }
    
    init(container: UICollectionView) {
        self.container = Collection(collection: container)
    }
    
    
    //Время жизни кэша
    private let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60
    
    private static let pathName: String = {
        
        let pathName = "images"
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            
        }
        
        print("private static let pathName")
        
        return pathName
        
    }()
    
    
    private func getFilePath(url: String) -> String? {
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hashName = url.split(separator: "/").last ?? "default"
        
        print("private func getFilePath")
        return cachesDirectory.appendingPathComponent(PhotoToCacheSaver.pathName + "/" + hashName).path
    
    }
    
    private func saveImageToCache(url: String, image: UIImage) {
        
        guard let fileName = getFilePath(url: url),
              let data = image.pngData()  else { return }
        
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
        
        print("private func saveImageToCache")
        
    }
    
    private func getImageFromCache(url: String) -> UIImage? {
        
        guard let fileName = getFilePath(url: url),
              let info = try? FileManager.default.attributesOfItem(atPath: fileName),
              let modificationDate = info[FileAttributeKey.modificationDate] as? Date
        else { return nil }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime,
              let image = UIImage(contentsOfFile: fileName) else { return nil }
        
        DispatchQueue.main.async {
            self.images[url] = image
        }
        
        print("private func getImageFromCache")
        return image
    }
    
    
    private func loadPhoto(atIndexPath indexPath: IndexPath, byUrl url: String) {
        
        AF.request(url).responseData(queue: .global()) { [weak self] response in
            guard let data = response.data,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.images[url] = image
            }
            
            self?.saveImageToCache(url: url, image: image)
            DispatchQueue.main.async {
                self?.container.reloadRow(atIndexPath: indexPath)
            }
        }
        
        print("private func loadPhoto")
        
    }
    
    
    func photo(atIndexPath indexPath: IndexPath, byUrl url: String) -> UIImage? {
        
        var image: UIImage?
        
        if let photo = images[url] {
            image = photo
            print("from memory")
        } else if let photo = getImageFromCache(url: url) {
            image = photo
            print("getImageFromCache")
        } else {
            loadPhoto(atIndexPath: indexPath, byUrl: url)
            print("loadPhoto")
        }
        
        print("func photo")
        return image
    }
    
}


extension PhotoToCacheSaver {
    
    private class Table: DataReloadable {
        
        let table: UITableView
        
        init(table: UITableView) {
            self.table = table
        }
        
        func reloadRow(atIndexPath IndexPath: IndexPath) {
            table.reloadRows(at: [IndexPath], with: .none)
        }
        
    }


    private class Collection: DataReloadable {
        
        let collection: UICollectionView
        
        init(collection: UICollectionView) {
            self.collection = collection
        }
        
        func reloadRow(atIndexPath IndexPath: IndexPath) {
            collection.reloadItems(at: [IndexPath])
        }
        
    }
    
}

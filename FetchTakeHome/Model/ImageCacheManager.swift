//
//  ImageCacheManager.swift
//  FetchTakeHome
//
//  Created by Justin Wells on 1/30/25.
//

import UIKit

actor ImageCacheManager {
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() throws {
        let directories = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = directories[0].appendingPathExtension("RecipeImages")
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    func getImage(for url: URL, recipeId: String) async throws -> UIImage? {
        // Use recipe ID for both memory and disk cache keys
        if let cachedImage = cache.object(forKey: recipeId as NSString) {
            return cachedImage
        }
        
        // Create a filename using the recipe ID
        let imagePath = cacheDirectory.appendingPathComponent("\(recipeId).jpg")
        
        if let imageData = try? Data(contentsOf: imagePath),
           let diskImage = UIImage(data: imageData) {
            // Store in memory for faster access next time
            cache.setObject(diskImage, forKey: recipeId as NSString)
            return diskImage
        }
        
        return nil
    }
    
    func saveImage(_ image: UIImage, for url: URL, recipeId: String) throws {
        // Save to memory cache using recipe ID
        cache.setObject(image, forKey: recipeId as NSString)
        
        // Save to Disk using recipe ID as filename
        let imagePath = cacheDirectory.appendingPathComponent("\(recipeId).jpg")
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        try data.write(to: imagePath)
    }
}

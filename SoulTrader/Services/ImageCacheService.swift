//
//  ImageCacheService.swift
//  SoulTrader
//
//  Handles downloading, caching, and retrieval of stock logo images
//

import SwiftUI
import Foundation

class ImageCacheService: ObservableObject {
    static let shared = ImageCacheService()
    
    private let cacheDirectory: URL
    private let fileManager = FileManager.default
    private let session = URLSession.shared
    
    // In-memory cache for quick access
    private var memoryCache: [String: UIImage] = [:]
    private let maxMemoryCacheSize = 50 // Maximum number of images in memory
    private let memoryCacheQueue = DispatchQueue(label: "com.soultrader.memorycache", attributes: .concurrent)
    
    private init() {
        // Create cache directory in Documents
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        cacheDirectory = documentsPath.appendingPathComponent("StockLogos")
        
        // Create cache directory if it doesn't exist
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        
        // Clean up old cache files on startup
        cleanupOldCache()
    }
    
    // MARK: - Public Methods
    
    /// Get cached image or download if not cached
    func getImage(for symbol: String, logoUrl: String?) async -> UIImage? {
        let cacheKey = symbol.lowercased()
        
        // 1. Check memory cache first
        var cachedImage: UIImage?
        memoryCacheQueue.sync {
            cachedImage = memoryCache[cacheKey]
        }
        if let cachedImage = cachedImage {
            return cachedImage
        }
        
        // 2. Check disk cache
        if let diskImage = loadFromDisk(cacheKey: cacheKey) {
            // Store in memory cache for faster access
            storeInMemoryCache(key: cacheKey, image: diskImage)
            return diskImage
        }
        
        // 3. Download and cache if URL is available
        if let logoUrl = logoUrl, !logoUrl.isEmpty {
            if let downloadedImage = await downloadAndCache(symbol: symbol, url: logoUrl) {
                return downloadedImage
            }
        }
        
        // 4. Return nil if no image available (will show initials)
        return nil
    }
    
    /// Clear all cached images
    func clearCache() {
        // Clear memory cache
        memoryCacheQueue.async(flags: .barrier) {
            self.memoryCache.removeAll()
        }
        
        // Clear disk cache
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    /// Get cache size in MB
    func getCacheSize() -> Double {
        guard let enumerator = fileManager.enumerator(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey]) else {
            return 0
        }
        
        var totalSize: Int64 = 0
        for case let fileURL as URL in enumerator {
            if let fileSize = try? fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize {
                totalSize += Int64(fileSize)
            }
        }
        
        return Double(totalSize) / (1024 * 1024) // Convert to MB
    }
    
    // MARK: - Private Methods
    
    private func downloadAndCache(symbol: String, url: String) async -> UIImage? {
        guard let imageURL = URL(string: buildFullURL(from: url)) else {
            return nil
        }
        
        do {
            let (data, _) = try await session.data(from: imageURL)
            guard let image = UIImage(data: data) else {
                return nil
            }
            
            let cacheKey = symbol.lowercased()
            
            // Store in disk cache
            saveToDisk(cacheKey: cacheKey, image: image)
            
            // Store in memory cache
            storeInMemoryCache(key: cacheKey, image: image)
            
            return image
            
        } catch {
            print("Failed to download image for \(symbol): \(error)")
            return nil
        }
    }
    
    private func loadFromDisk(cacheKey: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent("\(cacheKey).png")
        
        guard fileManager.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
    
    private func saveToDisk(cacheKey: String, image: UIImage) {
        let fileURL = cacheDirectory.appendingPathComponent("\(cacheKey).png")
        
        guard let data = image.pngData() else {
            return
        }
        
        try? data.write(to: fileURL)
    }
    
    private func storeInMemoryCache(key: String, image: UIImage) {
        memoryCacheQueue.async(flags: .barrier) {
            // Remove oldest entries if cache is full
            if self.memoryCache.count >= self.maxMemoryCacheSize {
                let oldestKey = self.memoryCache.keys.first
                if let oldestKey = oldestKey {
                    self.memoryCache.removeValue(forKey: oldestKey)
                }
            }
            
            self.memoryCache[key] = image
        }
    }
    
    private func buildFullURL(from url: String) -> String {
        // If it's already a full URL, return it
        if url.hasPrefix("http") {
            return url
        }
        
        // If it's a relative path, make it absolute
        if url.hasPrefix("/static/") {
            return "http://192.168.1.6:8000\(url)"
        }
        
        // Default fallback
        return url
    }
    
    private func cleanupOldCache() {
        // Remove cache files older than 7 days
        let sevenDaysAgo = Date().addingTimeInterval(-7 * 24 * 60 * 60)
        
        guard let enumerator = fileManager.enumerator(at: cacheDirectory, includingPropertiesForKeys: [.creationDateKey]) else {
            return
        }
        
        for case let fileURL as URL in enumerator {
            if let creationDate = try? fileURL.resourceValues(forKeys: [.creationDateKey]).creationDate,
               creationDate < sevenDaysAgo {
                try? fileManager.removeItem(at: fileURL)
            }
        }
    }
}

// MARK: - SwiftUI View Extension

struct CachedAsyncImage: View {
    let symbol: String
    let logoUrl: String?
    let size: CGFloat
    
    @State private var image: UIImage?
    @State private var isLoading = false
    
    init(symbol: String, logoUrl: String?, size: CGFloat = 40) {
        self.symbol = symbol
        self.logoUrl = logoUrl
        self.size = size
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else if isLoading {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: size, height: size)
                    .overlay(ProgressView().scaleEffect(0.7))
            } else {
                // Fallback to initials
                Circle()
                    .fill(Color.purple.opacity(0.2))
                    .frame(width: size, height: size)
                    .overlay(
                        Text(symbol.prefix(2))
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                    )
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        isLoading = true
        let loadedImage = await ImageCacheService.shared.getImage(for: symbol, logoUrl: logoUrl)
        await MainActor.run {
            self.image = loadedImage
            self.isLoading = false
        }
    }
}

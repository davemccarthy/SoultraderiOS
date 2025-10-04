//
//  Constants.swift
//  SoulTrader
//
//  Created on 2025-09-30
//

import Foundation

struct AppConstants {
    // API Configuration
    static let baseAPIURL = "http://192.168.1.6:8000/api"
    static let baseServerURL = "http://192.168.1.6:8000"
    
    // Helper to convert relative logo URL to full URL
    static func fullLogoURL(from relativePath: String?) -> URL? {
        guard let path = relativePath, 
              !path.isEmpty, 
              path != "null",
              path.hasPrefix("/") else { 
            return nil 
        }
        return URL(string: "\(baseServerURL)\(path)")
    }
}


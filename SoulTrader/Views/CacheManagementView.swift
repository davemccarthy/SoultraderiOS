//
//  CacheManagementView.swift
//  SoulTrader
//
//  Cache management view for image cache
//

import SwiftUI

struct CacheManagementView: View {
    @StateObject private var imageCache = ImageCacheService.shared
    @State private var cacheSize: Double = 0.0
    @State private var showingClearAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Cache Info
            VStack(spacing: 12) {
                Text("Image Cache")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Cache Size: \(String(format: "%.2f", cacheSize)) MB")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Stock logos are cached locally for faster loading and offline access.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Cache Actions
            VStack(spacing: 16) {
                Button(action: {
                    showingClearAlert = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Clear Cache")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                }
                
                Button(action: {
                    refreshCacheSize()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Refresh Cache Info")
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Cache Management")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            refreshCacheSize()
        }
        .alert("Clear Cache", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                clearCache()
            }
        } message: {
            Text("This will remove all cached stock logos. Images will be downloaded again when needed.")
        }
    }
    
    private func refreshCacheSize() {
        cacheSize = imageCache.getCacheSize()
    }
    
    private func clearCache() {
        imageCache.clearCache()
        refreshCacheSize()
    }
}

#Preview {
    NavigationView {
        CacheManagementView()
    }
}



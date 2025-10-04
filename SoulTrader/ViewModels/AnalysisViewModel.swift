//
//  AnalysisViewModel.swift
//  SoulTrader
//
//  Created on 2025-09-30
//

import Foundation

@MainActor
class AnalysisViewModel: ObservableObject {
    @Published var session: AnalysisSession?
    @Published var recommendations: [SmartRecommendation] = []
    @Published var isLoading = false
    @Published var error: String?
    
    func loadData() async {
        isLoading = true
        error = nil
        
        do {
            let response = try await APIService.shared.getSmartAnalysis()
            self.session = response.latestSession
            self.recommendations = response.recommendations
        } catch {
            self.error = error.localizedDescription
            print("Error loading smart analysis: \(error)")
        }
        
        isLoading = false
    }
}


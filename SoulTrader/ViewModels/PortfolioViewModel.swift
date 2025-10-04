//
//  PortfolioViewModel.swift
//  SoulTrader
//
//  Created on 2025-09-30
//

import Foundation

@MainActor
class PortfolioViewModel: ObservableObject {
    @Published var holdings: [Holding] = []
    @Published var portfolioSummary: PortfolioSummary?
    @Published var isLoading = false
    @Published var error: String?
    
    func loadData() async {
        isLoading = true
        error = nil
        
        do {
            let response = try await APIService.shared.getPortfolioHoldings()
            self.portfolioSummary = response.portfolioSummary
            self.holdings = response.holdings
        } catch {
            self.error = error.localizedDescription
            print("Error loading portfolio: \(error)")
        }
        
        isLoading = false
    }
}


//
//  TradesViewModel.swift
//  SoulTrader
//
//  Created on 2025-09-30
//

import Foundation

@MainActor
class TradesViewModel: ObservableObject {
    @Published var trades: [Trade] = []
    @Published var tradeSummary: TradeSummary?
    @Published var isLoading = false
    @Published var error: String?
    
    func loadData(limit: Int = 20) async {
        isLoading = true
        error = nil
        
        do {
            // Load both trades and summary data
            async let tradesResponse = APIService.shared.getRecentTrades(limit: limit)
            async let summaryResponse = APIService.shared.getTradeSummary()
            
            let (tradesResult, summaryResult) = try await (tradesResponse, summaryResponse)
            
            self.trades = tradesResult.results
            self.tradeSummary = summaryResult
        } catch {
            self.error = error.localizedDescription
            print("Error loading trades: \(error)")
        }
        
        isLoading = false
    }
    
    func loadTradesForStock(symbol: String) async {
        isLoading = true
        error = nil
        
        do {
            let response = try await APIService.shared.getTradesForStock(symbol: symbol)
            self.trades = response.trades
        } catch {
            self.error = error.localizedDescription
            print("Error loading trades for \(symbol): \(error)")
        }
        
        isLoading = false
    }
}


//
//  PortfolioView.swift
//  SoulTrader
//
//  Created on 2025-09-30
//

import SwiftUI

struct PortfolioView: View {
    @StateObject private var viewModel = PortfolioViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Portfolio Summary Card
                    if let summary = viewModel.portfolioSummary {
                        SummaryCard.portfolio(summary: summary)
                    }
                    
                    // Holdings List
                    if !viewModel.holdings.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Holdings")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            List {
                                ForEach(viewModel.holdings) { holding in
                                    NavigationLink(destination: TradeView(stockSymbol: holding.stock.symbol, stockName: holding.stock.name, holding: holding)) {
                                        StockRow.holdingRow(holding: holding)
                                    }
                                }
                            }
                            .listStyle(.plain)
                            .frame(height: CGFloat(viewModel.holdings.count * 70) + 20) // Increased height + padding
                        }
                    } else if !viewModel.isLoading {
                        Text("No holdings yet")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                    
                    // Error message
                    if let error = viewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("PORTFOLIO")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("PORTFOLIO")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.purple)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Logout") {
                        APIService.shared.logout()
                    }
                    .foregroundColor(.red)
                }
            }
            .refreshable {
                await viewModel.loadData()
            }
            .task {
                await viewModel.loadData()
            }
        }
    }
}




#Preview {
    PortfolioView()
}

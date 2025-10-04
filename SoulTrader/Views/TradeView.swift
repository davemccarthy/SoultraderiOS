//
//  TradeView.swift
//  SoulTrader
//
//  Created on 2025-10-03
//

import SwiftUI

struct TradeView: View {
    @StateObject private var viewModel = TradesViewModel()
    let stockSymbol: String?
    let stockName: String?
    let holding: Holding?
    
    init(stockSymbol: String? = nil, stockName: String? = nil, holding: Holding? = nil) {
        self.stockSymbol = stockSymbol
        self.stockName = stockName
        self.holding = holding
    }
    
    var filteredTrades: [Trade] {
        if let stockSymbol = stockSymbol {
            return viewModel.trades.filter { $0.stock.symbol == stockSymbol }
        }
        return viewModel.trades
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Summary Card (holdings or trades)
                    if let holding = holding {
                        SummaryCard.trades(summary: TradeSummary(
                            totalValue: holding.currentValue,
                            availableCash: 0.0,
                            totalInvested: Double(holding.quantity) * holding.averagePrice,
                            totalCurrentValue: holding.currentValue,
                            totalUnrealizedPnl: holding.unrealizedPnl,
                            totalUnrealizedPnlPercent: holding.unrealizedPnlPercent,
                            tradesCount: filteredTrades.count,
                            sharesCount: holding.quantity
                        ))
                    } else if let summary = viewModel.tradeSummary {
                        SummaryCard.trades(summary: summary)
                    }
                    
                    // Trades List
                    if !filteredTrades.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(headerTitle)
                                .font(.headline)
                                .padding(.horizontal)
                            
                            List {
                                ForEach(filteredTrades) { trade in
                                    if trade.tradeSource == "SMART_ANALYSIS" {
                                        NavigationLink(destination: AnalysisDetailView(trade: trade)) {
                                            StockRow.tradeRow(trade: trade)
                                        }
                                    } else {
                                        StockRow.tradeRow(trade: trade, showAnalysisIndicator: false)
                                    }
                                }
                            }
                            .listStyle(.plain)
                            .frame(height: CGFloat(filteredTrades.count * 70) + 20)
                        }
                    } else if !viewModel.isLoading {
                        Text(emptyMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                    
                    if let error = viewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding(.vertical)
            }
            .refreshable {
                await viewModel.loadData()
            }
            .task {
                await viewModel.loadData()
            }
            .overlay {
                if viewModel.isLoading && viewModel.trades.isEmpty {
                    ProgressView()
                }
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(navigationTitle)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.purple)
            }
        }
    }
    
    private var headerTitle: String {
        stockName?.uppercased() ?? "Recent Trades"
    }
    
    private var emptyMessage: String {
        stockSymbol != nil ? "No trades found for this stock" : "No trades yet"
    }
    
    private var navigationTitle: String {
        stockSymbol != nil ? stockName?.uppercased() ?? "Trades" : "Trades"
    }
}


#Preview {
    TradeView()
}

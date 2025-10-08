//
//  AnalysisView.swift
//  SoulTrader
//
//  Created on 2025-09-30
//

import SwiftUI

struct AnalysisView: View {
    let trade: Trade
    @StateObject private var viewModel = TradeAnalysisViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Panel A: Summary
                VStack(spacing: 12) {
                    // Stock Info Row
                    HStack(spacing: 12) {
                        // Stock Logo (using CachedAsyncImage like other views)
                        CachedAsyncImage(symbol: trade.stock.symbol, logoUrl: trade.stock.logoUrl, size: 40)
                        
                        // Stock Name and Symbol (swapped)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(trade.stock.name)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                            Text(trade.stock.symbol)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    // Action and Confidence Row
                    HStack {
                        let actionText = "\(trade.tradeType) \(trade.quantity) shares"
                        
                        Text(actionText)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(trade.tradeType == "BUY" ? .green : .red)
                        
                        Text("•")
                            .foregroundColor(.secondary)
                        
                        Text("\(Int((viewModel.tradeAnalysis?.technicalDetails.confidenceScore ?? 0.87) * 100))% confidence")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    
                    // Advisor Count and Cash Row
                    HStack {
                        Text("\(viewModel.tradeAnalysis?.advisorRecommendations.count ?? 6) advisors")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("•")
                            .foregroundColor(.secondary)
                        
                        Text("$\(trade.totalAmount, specifier: "%.0f") allocated")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(trade.tradeType == "BUY" ? .green : .red)
                        
                        Spacer()
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                // Panel B: Smart Analysis Algorithm Steps
                if let tradeAnalysis = viewModel.tradeAnalysis {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Smart Analysis")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(Array(tradeAnalysis.algorithmSteps.enumerated()), id: \.offset) { index, step in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("\(index + 1).")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.purple)
                                    
                                    Text(step)
                                        .font(.subheadline)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                } else if viewModel.isLoading {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Smart Analysis")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(0..<3, id: \.self) { index in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("\(index + 1).")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.purple)
                                        .redacted(reason: .placeholder)
                                    
                                    Text("Loading algorithm step...")
                                        .font(.subheadline)
                                        .redacted(reason: .placeholder)
                                    
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                }
                
                // Panel C: Advisor Synopsis
                if let tradeAnalysis = viewModel.tradeAnalysis {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Advisor Synopsis")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(tradeAnalysis.advisorRecommendations) { advisor in
                                VStack(alignment: .leading, spacing: 4) {
                                    // First row: Badge + Advisor name
                                    HStack(spacing: 8) {
                                        Text(advisor.recommendationType)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .frame(minWidth: 50, alignment: .center)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(
                                                advisor.recommendationType.contains("BUY") ? Color.green :
                                                advisor.recommendationType.contains("SELL") ? Color.red : Color.orange
                                            )
                                            .cornerRadius(4)
                                        
                                        Text(advisor.advisorName)
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                        
                                        Spacer()
                                    }
                                    
                                    // Second row: Detail text (full width)
                                    Text("\(advisor.reasoning) (\(Int(advisor.confidenceScore * 100))% confidence)")
                                        .font(.subheadline)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                } else if viewModel.isLoading {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Advisor Synopsis")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(0..<3, id: \.self) { _ in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 8) {
                                        Text("LOAD")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .frame(minWidth: 50, alignment: .center)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.gray)
                                            .cornerRadius(4)
                                            .redacted(reason: .placeholder)
                                        
                                        Text("Loading...")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .redacted(reason: .placeholder)
                                        
                                        Spacer()
                                    }
                                    
                                    Text("Loading advisor recommendation...")
                                        .font(.subheadline)
                                        .redacted(reason: .placeholder)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                }
                
                // Panel D: Technical Metrics
                if let tradeAnalysis = viewModel.tradeAnalysis {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Technical Metrics")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Priority Score:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(Int(tradeAnalysis.technicalDetails.priorityScore))/100")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            
                            HStack {
                                Text("Confidence Score:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(Int(tradeAnalysis.technicalDetails.confidenceScore * 100))%")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            
                            HStack {
                                Text("Current Price:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("$\(tradeAnalysis.technicalDetails.currentPrice, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            
                            if let targetPrice = tradeAnalysis.technicalDetails.targetPrice {
                                HStack {
                                    Text("Target Price:")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("$\(targetPrice, specifier: "%.2f")")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.green)
                                }
                            }
                            
                            if let stopLoss = tradeAnalysis.technicalDetails.stopLoss {
                                HStack {
                                    Text("Stop Loss:")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("$\(stopLoss, specifier: "%.2f")")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                } else if viewModel.isLoading {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Technical Metrics")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(0..<5, id: \.self) { _ in
                                HStack {
                                    Text("Loading...")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .redacted(reason: .placeholder)
                                    Spacer()
                                    Text("Loading...")
                                        .font(.subheadline)
                                        .redacted(reason: .placeholder)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                }
                
                // Panel E: Trade Details
                VStack(alignment: .leading, spacing: 12) {
                    Text("Trade Details")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Trade Type:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(trade.tradeType)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(trade.tradeType == "BUY" ? .green : .red)
                        }
                        
                        HStack {
                            Text("Order Type:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(trade.orderType)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        
                        HStack {
                            Text("Quantity:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(trade.quantity) shares")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        
                        HStack {
                            Text("Total Amount:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("$\(trade.totalAmount, specifier: "%.2f")")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        
                        HStack {
                            Text("Commission:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("$\(trade.commission, specifier: "%.2f")")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        
                        HStack {
                            Text("Status:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(trade.status)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(trade.status == "FILLED" ? .green : .orange)
                        }
                        
                        HStack {
                            Text("Trade Source:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(trade.tradeSource)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        
                        if let executedAt = trade.executedAt {
                            HStack {
                                Text("Executed:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(executedAt.formatted(date: .abbreviated, time: .shortened))
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                }
                
                // Error message
                if let error = viewModel.error {
                    Text("Error loading analysis: \(error)")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("ANALYSIS")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("ANALYSIS")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.purple)
            }
        }
        .task {
            await viewModel.loadTradeAnalysis(tradeId: trade.id)
        }
    }
}

// MARK: - Trade Analysis ViewModel

@MainActor
class TradeAnalysisViewModel: ObservableObject {
    @Published var tradeAnalysis: TradeAnalysisResponse?
    @Published var isLoading = false
    @Published var error: String?
    
    func loadTradeAnalysis(tradeId: String) async {
        isLoading = true
        error = nil
        
        do {
            tradeAnalysis = try await APIService.shared.getTradeAnalysis(tradeId: tradeId)
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
}

#Preview {
    AnalysisView(trade: Trade.sampleTrade)
}

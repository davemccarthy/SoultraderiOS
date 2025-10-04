//
//  SummaryCard.swift
//  SoulTrader
//
//  Created on 2025-10-03
//

import SwiftUI

// MARK: - Summary Card Protocol

protocol SummaryCardData {
    var totalValue: Double { get }
    var totalUnrealizedPnl: Double { get }
    var totalUnrealizedPnlPercent: Double { get }
    var availableCash: Double { get }
    var totalInvested: Double { get }
}

// MARK: - Portfolio Summary Data

struct PortfolioSummaryData: SummaryCardData {
    let totalValue: Double
    let totalUnrealizedPnl: Double
    let totalUnrealizedPnlPercent: Double
    let availableCash: Double
    let totalInvested: Double
    let holdingsCount: Int
    
    init(from summary: PortfolioSummary) {
        self.totalValue = summary.totalValue
        self.totalUnrealizedPnl = summary.totalUnrealizedPnl
        self.totalUnrealizedPnlPercent = summary.totalUnrealizedPnlPercent
        self.availableCash = summary.availableCash
        self.totalInvested = summary.totalInvested
        self.holdingsCount = summary.holdingsCount
    }
}

// MARK: - Trade Summary Data

struct TradeSummaryData: SummaryCardData {
    let totalValue: Double
    let totalUnrealizedPnl: Double
    let totalUnrealizedPnlPercent: Double
    let availableCash: Double
    let totalInvested: Double
    let tradesCount: Int
    let sharesCount: Int
    
    init(from summary: TradeSummary) {
        self.totalValue = summary.totalValue
        self.totalUnrealizedPnl = summary.totalUnrealizedPnl
        self.totalUnrealizedPnlPercent = summary.totalUnrealizedPnlPercent
        self.availableCash = summary.availableCash
        self.totalInvested = summary.totalInvested
        self.tradesCount = summary.tradesCount
        self.sharesCount = summary.sharesCount
    }
}

// MARK: - Generic Summary Card

struct SummaryCard: View {
    let data: SummaryCardData
    let mode: SummaryCardMode
    
    enum SummaryCardMode {
        case portfolio
        case trades
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Total Value & P/L (Top 3 - same for both modes)
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Value")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "$%.2f", data.totalValue))
                        .font(.title)
                        .fontWeight(.bold)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("P&L")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "$%.2f", data.totalUnrealizedPnl))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(data.totalUnrealizedPnl >= 0 ? .green : .red)
                    Text(String(format: "%.2f%%", data.totalUnrealizedPnlPercent))
                        .font(.caption)
                        .foregroundColor(data.totalUnrealizedPnlPercent >= 0 ? .green : .red)
                }
            }
            
            Divider()
            
            // Bottom 3: Different for each mode
            HStack(spacing: 20) {
                switch mode {
                case .portfolio:
                    InfoItem(label: "Cash", value: String(format: "$%.2f", data.availableCash))
                    Spacer()
                    InfoItem(label: "Invested", value: String(format: "$%.2f", data.totalInvested))
                    Spacer()
                    if let portfolioData = data as? PortfolioSummaryData {
                        InfoItem(label: "Holdings", value: "\(portfolioData.holdingsCount)")
                    }
                case .trades:
                    if let tradeData = data as? TradeSummaryData {
                        InfoItem(label: "Trades", value: "\(tradeData.tradesCount)")
                    }
                    Spacer()
                    InfoItem(label: "Invested", value: String(format: "$%.2f", data.totalInvested))
                    Spacer()
                    if let tradeData = data as? TradeSummaryData {
                        InfoItem(label: "Shares", value: "\(tradeData.sharesCount)")
                    }
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

// MARK: - Info Item Component

struct InfoItem: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Convenience Initializers

extension SummaryCard {
    static func portfolio(summary: PortfolioSummary) -> SummaryCard {
        SummaryCard(
            data: PortfolioSummaryData(from: summary),
            mode: .portfolio
        )
    }
    
    static func trades(summary: TradeSummary) -> SummaryCard {
        SummaryCard(
            data: TradeSummaryData(from: summary),
            mode: .trades
        )
    }
    
}

// MARK: - Preview

#Preview("Portfolio Mode") {
    SummaryCard.portfolio(summary: PortfolioSummary(
        totalValue: 125847.50,
        availableCash: 149.30,
        totalInvested: 100840.00,
        totalCurrentValue: 125698.20,
        totalUnrealizedPnl: 24858.20,
        totalUnrealizedPnlPercent: 24.65,
        holdingsCount: 8
    ))
}

#Preview("Trades Mode") {
    SummaryCard.trades(summary: TradeSummary(
        totalValue: 125847.50,
        availableCash: 149.30,
        totalInvested: 100840.00,
        totalCurrentValue: 125698.20,
        totalUnrealizedPnl: 24858.20,
        totalUnrealizedPnlPercent: 24.65,
        tradesCount: 15,
        sharesCount: 1250
    ))
}


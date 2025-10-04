//
//  StockRow.swift
//  SoulTrader
//
//  Unified stock row component for consistent UI across all views
//

import SwiftUI

struct StockRow: View {
    // Core stock data
    let stock: Stock
    let value: String
    let aux1: String
    let aux2: String
    
    // Optional customization
    let valueColor: Color
    let aux2Color: Color
    let showIndicator: Bool
    let indicatorIcon: String?
    let indicatorColor: Color?
    
    init(
        stock: Stock,
        value: String,
        aux1: String,
        aux2: String,
        valueColor: Color = .primary,
        aux2Color: Color = .secondary,
        showIndicator: Bool = false,
        indicatorIcon: String? = nil,
        indicatorColor: Color? = nil
    ) {
        self.stock = stock
        self.value = value
        self.aux1 = aux1
        self.aux2 = aux2
        self.valueColor = valueColor
        self.aux2Color = aux2Color
        self.showIndicator = showIndicator
        self.indicatorIcon = indicatorIcon
        self.indicatorColor = indicatorColor
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Stock logo with caching
            CachedAsyncImage(symbol: stock.symbol, logoUrl: stock.logoUrl, size: 40)
            
            // Left side: Company Name and Symbol + aux1
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(stock.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    // Optional indicator (e.g., brain icon for AI analysis)
                    if showIndicator, let icon = indicatorIcon {
                        Image(systemName: icon)
                            .font(.caption)
                            .foregroundColor(indicatorColor ?? .purple)
                    }
                    
                    Spacer()
                }
                
                HStack(spacing: 4) {
                    Text(stock.symbol)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(aux1)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Right side: Value and aux2
            VStack(alignment: .trailing, spacing: 2) {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(valueColor)
                
                Text(aux2)
                    .font(.caption)
                    .foregroundColor(aux2Color)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Convenience Initializers for Different Views

extension StockRow {
    // For Trades View
    static func tradeRow(
        trade: Trade,
        showAnalysisIndicator: Bool = true
    ) -> StockRow {
        let aux1 = "\(trade.tradeType) • \(trade.quantity) shares"
        let aux2 = trade.executedAt?.formatted(date: .abbreviated, time: .omitted) ?? "Pending"
        
        return StockRow(
            stock: trade.stock,
            value: String(format: "$%.2f", trade.totalAmount),
            aux1: aux1,
            aux2: aux2,
            valueColor: .primary,
            aux2Color: .secondary,
            showIndicator: showAnalysisIndicator && trade.tradeSource == "SMART_ANALYSIS",
            indicatorIcon: "brain.head.profile",
            indicatorColor: .purple
        )
    }
    
    // For Portfolio View (Holdings)
    static func holdingRow(
        holding: Holding
    ) -> StockRow {
        let aux1 = "\(holding.quantity) shares"
        let aux2 = String(format: "%@%.2f%%", 
                         holding.unrealizedPnlPercent >= 0 ? "+" : "", 
                         holding.unrealizedPnlPercent)
        
        return StockRow(
            stock: holding.stock,
            value: String(format: "$%.2f", holding.currentValue),
            aux1: aux1,
            aux2: aux2,
            valueColor: .primary,
            aux2Color: holding.unrealizedPnlPercent >= 0 ? .green : .red
        )
    }
    
    // For Analysis View (Recommendations)
    static func recommendationRow(
        recommendation: SmartRecommendation
    ) -> StockRow {
        let aux1 = "\(recommendation.recommendationType) • \(recommendation.sharesToBuy ?? 0) shares"
        let aux2 = String(format: "%.0f%% confidence", recommendation.confidenceScore * 100)
        
        let valueColor: Color = {
            switch recommendation.recommendationType {
            case "BUY", "STRONG_BUY": return .green
            case "SELL", "STRONG_SELL": return .red
            default: return .orange
            }
        }()
        
        return StockRow(
            stock: recommendation.stock,
            value: String(format: "$%.2f", recommendation.cashAllocated ?? 0),
            aux1: aux1,
            aux2: aux2,
            valueColor: valueColor,
            aux2Color: .secondary
        )
    }
}


// MARK: - Preview

#Preview("Trade Row") {
    VStack {
        StockRow.tradeRow(trade: Trade.sampleTrade)
        StockRow.holdingRow(holding: Holding.sampleHolding)
        StockRow.recommendationRow(recommendation: SmartRecommendation.sampleRecommendation)
    }
    .padding()
}

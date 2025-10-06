//
//  SmartAnalysisSummaryCard.swift
//  SoulTrader
//
//  Created on 2025-01-27
//

import SwiftUI

// MARK: - Smart Analysis Summary Data

struct SmartAnalysisSummaryData {
    let stock: Stock
    let recommendationType: String
    let sharesQuantity: Int?
    let confidenceScore: Double
    let advisorCount: Int
    let cashAmount: Double
    
    // Computed properties for display
    var confidencePercentage: String {
        String(format: "%.0f%%", confidenceScore * 100)
    }
    
    var actionText: String {
        if let shares = sharesQuantity {
            return "\(recommendationType) \(shares) shares"
        } else {
            return recommendationType
        }
    }
    
    var cashText: String {
        if recommendationType == "SELL" {
            return String(format: "$%.0f from sale", cashAmount)
        } else {
            return String(format: "$%.0f allocated", cashAmount)
        }
    }
    
    var actionColor: Color {
        switch recommendationType {
        case "BUY":
            return .green
        case "SELL":
            return .red
        case "HOLD":
            return .orange
        default:
            return .primary
        }
    }
}

// MARK: - Smart Analysis Summary Card

struct SmartAnalysisSummaryCard: View {
    let data: SmartAnalysisSummaryData
    
    var body: some View {
        VStack(spacing: 12) {
            // Stock Info Row
            HStack(spacing: 12) {
                // Stock Logo
                AsyncImage(url: URL(string: data.stock.logoUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Circle()
                        .fill(Color.purple.opacity(0.2))
                        .overlay(
                            Text(data.stock.symbol.prefix(2))
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                        )
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
                // Stock Symbol and Name
                VStack(alignment: .leading, spacing: 2) {
                    Text(data.stock.symbol)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(data.stock.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
            }
            
            Divider()
            
            // Action and Confidence Row
            HStack {
                Text(data.actionText)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(data.actionColor)
                
                Text("•")
                    .foregroundColor(.secondary)
                
                Text("\(data.confidencePercentage) confidence")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            // Advisor Count and Cash Row
            HStack {
                Text("\(data.advisorCount) advisors")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("•")
                    .foregroundColor(.secondary)
                
                Text(data.cashText)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(data.actionColor)
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

// MARK: - Convenience Initializer

extension SmartAnalysisSummaryCard {
    static func from(recommendation: SmartRecommendation) -> SmartAnalysisSummaryCard {
        let summaryData = SmartAnalysisSummaryData(
            stock: recommendation.stock,
            recommendationType: recommendation.recommendationType,
            sharesQuantity: recommendation.sharesToBuy,
            confidenceScore: recommendation.confidenceScore,
            advisorCount: 6, // TODO: Get actual advisor count from API
            cashAmount: recommendation.cashAllocated ?? 0.0
        )
        
        return SmartAnalysisSummaryCard(data: summaryData)
    }
}

// MARK: - Preview

#Preview("BUY Recommendation") {
    SmartAnalysisSummaryCard(data: SmartAnalysisSummaryData(
        stock: Stock(
            symbol: "GOOGL",
            name: "Alphabet Inc.",
            logoUrl: nil,
            currentPrice: 150.25,
            previousClose: 148.50,
            dayChange: 1.75,
            dayChangePercent: 1.18,
            fmpGrade: "A+",
            currency: "USD",
            exchange: "NASDAQ",
            sector: "Technology"
        ),
        recommendationType: "BUY",
        sharesQuantity: 25,
        confidenceScore: 0.87,
        advisorCount: 6,
        cashAmount: 2500.0
    ))
}

#Preview("SELL Recommendation") {
    SmartAnalysisSummaryCard(data: SmartAnalysisSummaryData(
        stock: Stock(
            symbol: "TSLA",
            name: "Tesla, Inc.",
            logoUrl: nil,
            currentPrice: 245.80,
            previousClose: 250.20,
            dayChange: -4.40,
            dayChangePercent: -1.76,
            fmpGrade: "B+",
            currency: "USD",
            exchange: "NASDAQ",
            sector: "Automotive"
        ),
        recommendationType: "SELL",
        sharesQuantity: 10,
        confidenceScore: 0.72,
        advisorCount: 4,
        cashAmount: 1200.0
    ))
}

#Preview("HOLD Recommendation") {
    SmartAnalysisSummaryCard(data: SmartAnalysisSummaryData(
        stock: Stock(
            symbol: "AAPL",
            name: "Apple Inc.",
            logoUrl: nil,
            currentPrice: 185.50,
            previousClose: 184.20,
            dayChange: 1.30,
            dayChangePercent: 0.71,
            fmpGrade: "A",
            currency: "USD",
            exchange: "NASDAQ",
            sector: "Technology"
        ),
        recommendationType: "HOLD",
        sharesQuantity: nil,
        confidenceScore: 0.65,
        advisorCount: 5,
        cashAmount: 0.0
    ))
}

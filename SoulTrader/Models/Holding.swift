//
//  Holding.swift
//  SoulTrader
//
//  Created on 2025-09-30
//

import Foundation

struct Holding: Codable, Identifiable {
    let id: Int
    let stock: Stock
    let quantity: Int
    let averagePrice: Double
    let currentValue: Double
    let unrealizedPnl: Double
    let unrealizedPnlPercent: Double
    let purchaseDate: Date?
    let lastUpdated: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, stock, quantity
        case averagePrice = "average_price"
        case currentValue = "current_value"
        case unrealizedPnl = "unrealized_pnl"
        case unrealizedPnlPercent = "unrealized_pnl_percent"
        case purchaseDate = "purchase_date"
        case lastUpdated = "last_updated"
    }
}

struct PortfolioSummary: Codable {
    let totalValue: Double
    let availableCash: Double
    let totalInvested: Double
    let totalCurrentValue: Double
    let totalUnrealizedPnl: Double
    let totalUnrealizedPnlPercent: Double
    let holdingsCount: Int
    
    enum CodingKeys: String, CodingKey {
        case totalValue = "total_value"
        case availableCash = "available_cash"
        case totalInvested = "total_invested"
        case totalCurrentValue = "total_current_value"
        case totalUnrealizedPnl = "total_unrealized_pnl"
        case totalUnrealizedPnlPercent = "total_unrealized_pnl_percent"
        case holdingsCount = "holdings_count"
    }
}

struct PortfolioHoldingsResponse: Codable {
    let portfolioSummary: PortfolioSummary
    let holdings: [Holding]
    
    enum CodingKeys: String, CodingKey {
        case portfolioSummary = "portfolio_summary"
        case holdings
    }
}

// MARK: - Sample Data

extension Holding {
    static let sampleHolding = Holding(
        id: 1,
        stock: Stock.sampleStock,
        quantity: 100,
        averagePrice: 150.0,
        currentValue: 16500.0,
        unrealizedPnl: 1500.0,
        unrealizedPnlPercent: 10.0,
        purchaseDate: Date(),
        lastUpdated: Date()
    )
}

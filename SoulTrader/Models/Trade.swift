//
//  Trade.swift
//  SoulTrader
//
//  Created on 2025-09-30
//

import Foundation

struct Trade: Codable, Identifiable {
    let id: String
    let stock: Stock
    let tradeType: String
    let orderType: String
    let quantity: Int
    let price: Double?
    let averageFillPrice: Double?
    let totalAmount: Double
    let commission: Double
    let status: String
    let tradeSource: String
    let executedAt: Date?
    let createdAt: Date
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
        case id, stock, quantity, price, commission, status, notes
        case tradeType = "trade_type"
        case orderType = "order_type"
        case averageFillPrice = "average_fill_price"
        case totalAmount = "total_amount"
        case tradeSource = "trade_source"
        case executedAt = "executed_at"
        case createdAt = "created_at"
    }
}

struct TradesResponse: Codable {
    let count: Int
    let results: [Trade]
}

struct StockTradesResponse: Codable {
    let symbol: String
    let count: Int
    let trades: [Trade]
}

struct TradeSummary: Codable {
    let totalValue: Double
    let availableCash: Double
    let totalInvested: Double
    let totalCurrentValue: Double
    let totalUnrealizedPnl: Double
    let totalUnrealizedPnlPercent: Double
    let tradesCount: Int
    let sharesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case totalValue = "total_value"
        case availableCash = "available_cash"
        case totalInvested = "total_invested"
        case totalCurrentValue = "total_current_value"
        case totalUnrealizedPnl = "total_unrealized_pnl"
        case totalUnrealizedPnlPercent = "total_unrealized_pnl_percent"
        case tradesCount = "trades_count"
        case sharesCount = "shares_count"
    }
}

// MARK: - Sample Data

extension Trade {
    static let sampleTrade = Trade(
        id: "1",
        stock: Stock.sampleStock,
        tradeType: "BUY",
        orderType: "MARKET",
        quantity: 100,
        price: 150.0,
        averageFillPrice: 150.25,
        totalAmount: 15025.0,
        commission: 1.0,
        status: "FILLED",
        tradeSource: "SMART_ANALYSIS",
        executedAt: Date(),
        createdAt: Date(),
        notes: "AI recommendation"
    )
}

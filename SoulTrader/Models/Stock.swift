//
//  Stock.swift
//  SoulTrader
//
//  Created on 2025-09-30
//

import Foundation

struct Stock: Codable, Identifiable {
    var id: String { symbol }
    let symbol: String
    let name: String
    let logoUrl: String?
    let currentPrice: Double
    let previousClose: Double?
    let dayChange: Double?
    let dayChangePercent: Double?
    let fmpGrade: String?
    let currency: String
    let exchange: String?
    let sector: String?
    
    enum CodingKeys: String, CodingKey {
        case symbol, name
        case logoUrl = "logo_url"
        case currentPrice = "current_price"
        case previousClose = "previous_close"
        case dayChange = "day_change"
        case dayChangePercent = "day_change_percent"
        case fmpGrade = "fmp_grade"
        case currency, exchange, sector
    }
}

// MARK: - Sample Data

extension Stock {
    static let sampleStock = Stock(
        symbol: "AAPL",
        name: "Apple Inc.",
        logoUrl: "/static/soulstrader/images/logos/AAPL.png",
        currentPrice: 165.0,
        previousClose: 160.0,
        dayChange: 5.0,
        dayChangePercent: 3.13,
        fmpGrade: "A",
        currency: "USD",
        exchange: "NASDAQ",
        sector: "Technology"
    )
}

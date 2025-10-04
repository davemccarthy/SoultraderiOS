//
//  SmartRecommendation.swift
//  SoulTrader
//
//  Created on 2025-09-30
//

import Foundation

struct SmartRecommendation: Codable, Identifiable {
    let id: String  // Changed from Int to String to handle Django's ID format
    let stock: Stock
    let recommendationType: String
    let priorityScore: Double
    let confidenceScore: Double
    let sharesToBuy: Int?
    let cashAllocated: Double?
    let currentPrice: Double
    let targetPrice: Double?
    let stopLoss: Double?
    let reasoning: String
    let keyFactors: [String]
    let riskFactors: [String]
    let status: String
    let createdAt: Date
    let expiresAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, stock, status, reasoning
        case recommendationType = "recommendation_type"
        case priorityScore = "priority_score"
        case confidenceScore = "confidence_score"
        case sharesToBuy = "shares_to_buy"
        case cashAllocated = "cash_allocated"
        case currentPrice = "current_price"
        case targetPrice = "target_price"
        case stopLoss = "stop_loss"
        case keyFactors = "key_factors"
        case riskFactors = "risk_factors"
        case createdAt = "created_at"
        case expiresAt = "expires_at"
    }
}

struct AnalysisSession: Codable, Identifiable {
    let id: String  // Changed from Int to String to handle Django's ID format
    let status: String
    let startedAt: Date
    let completedAt: Date?
    let processingTimeSeconds: Double?
    let totalRecommendations: Int
    let executedRecommendations: Int
    let portfolioValue: Double
    let availableCash: Double
    
    enum CodingKeys: String, CodingKey {
        case id, status
        case startedAt = "started_at"
        case completedAt = "completed_at"
        case processingTimeSeconds = "processing_time_seconds"
        case totalRecommendations = "total_recommendations"
        case executedRecommendations = "executed_recommendations"
        case portfolioValue = "portfolio_value"
        case availableCash = "available_cash"
    }
}

struct SmartAnalysisResponse: Codable {
    let latestSession: AnalysisSession?
    let recommendations: [SmartRecommendation]
    let message: String?  // Added optional message field for when no analysis exists
    
    enum CodingKeys: String, CodingKey {
        case latestSession = "latest_session"
        case recommendations
        case message
    }
}

// MARK: - Sample Data

extension SmartRecommendation {
    static let sampleRecommendation = SmartRecommendation(
        id: "1",
        stock: Stock.sampleStock,
        recommendationType: "BUY",
        priorityScore: 85.0,
        confidenceScore: 0.75,
        sharesToBuy: 50,
        cashAllocated: 7500.0,
        currentPrice: 150.0,
        targetPrice: 180.0,
        stopLoss: 120.0,
        reasoning: "Strong fundamentals and positive momentum",
        keyFactors: ["Strong earnings", "Positive analyst ratings"],
        riskFactors: ["Market volatility", "Sector headwinds"],
        status: "ACTIVE",
        createdAt: Date(),
        expiresAt: Calendar.current.date(byAdding: .day, value: 7, to: Date())
    )
}

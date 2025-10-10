//
//  TradeAnalysis.swift
//  SoulTrader
//
//  Created on 2025-01-27
//

import Foundation

// MARK: - Trade Analysis Response

struct TradeAnalysisResponse: Codable {
    let trade: TradeAnalysisTrade
    let advisorRecommendations: [AdvisorRecommendation]
    let algorithmSteps: [String]
    let technicalDetails: TechnicalDetails
    
    enum CodingKeys: String, CodingKey {
        case trade
        case advisorRecommendations = "advisor_recommendations"
        case algorithmSteps = "algorithm_steps"
        case technicalDetails = "technical_details"
    }
}

// MARK: - Trade Analysis Trade

struct TradeAnalysisTrade: Codable {
    let id: String
    let stock: TradeAnalysisStock
    let tradeType: String
    let quantity: Int
    let totalAmount: Double
    let executedAt: Date?
    let tradeSource: String
    
    enum CodingKeys: String, CodingKey {
        case id, stock, quantity
        case tradeType = "trade_type"
        case totalAmount = "total_amount"
        case executedAt = "executed_at"
        case tradeSource = "trade_source"
    }
}

// MARK: - Trade Analysis Stock

struct TradeAnalysisStock: Codable {
    let symbol: String
    let name: String
    let logoUrl: String?
    let currentPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case symbol, name
        case logoUrl = "logo_url"
        case currentPrice = "current_price"
    }
}

// MARK: - Advisor Recommendation

struct AdvisorRecommendation: Codable, Identifiable {
    var id: String { advisorName }
    
    let advisorName: String
    let recommendationType: String
    let confidenceScore: Double
    let reasoning: String
    let targetPrice: Double?
    
    enum CodingKeys: String, CodingKey {
        case advisorName = "advisor_name"
        case recommendationType = "recommendation_type"
        case confidenceScore = "confidence_score"
        case reasoning
        case targetPrice = "target_price"
    }
}

// MARK: - Technical Details

struct TechnicalDetails: Codable {
    let priorityScore: Double
    let confidenceScore: Double
    let recommendationType: String
    let currentPrice: Double
    let targetPrice: Double?
    let stopLoss: Double?
    let keyFactors: [String]
    let riskFactors: [String]
    let reasoning: String
    
    enum CodingKeys: String, CodingKey {
        case priorityScore = "priority_score"
        case confidenceScore = "confidence_score"
        case recommendationType = "recommendation_type"
        case currentPrice = "current_price"
        case targetPrice = "target_price"
        case stopLoss = "stop_loss"
        case keyFactors = "key_factors"
        case riskFactors = "risk_factors"
        case reasoning
    }
}








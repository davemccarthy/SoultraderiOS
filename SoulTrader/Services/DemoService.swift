//
//  DemoService.swift
//  SoulTrader
//
//  Created on 2025-10-01
//

import Foundation

class DemoService {
    static let shared = DemoService()
    
    private init() {}
    
    // MARK: - Demo Data Generation
    
    func getDemoLoginResponse() -> LoginResponse {
        return LoginResponse(
            access: "demo_access_token",
            refresh: "demo_refresh_token",
            user: getDemoUser()
        )
    }
    
    func getDemoUser() -> User {
        return User(
            id: 1,
            username: "demouser",
            email: "demo@soultrader.com",
            firstName: "Demo",
            lastName: "User",
            profile: UserProfile(
                riskLevel: "MODERATE",
                investmentGoal: "GROWTH",
                timeHorizon: "MEDIUM_TERM",
                maxPositions: 20,
                esgFocused: false
            )
        )
    }
    
    func getDemoPortfolioHoldings() -> PortfolioHoldingsResponse {
        let summary = PortfolioSummary(
            totalValue: 125847.50,
            availableCash: 15420.75,
            totalInvested: 110426.75,
            totalCurrentValue: 115847.50,
            totalUnrealizedPnl: 5420.75,
            totalUnrealizedPnlPercent: 4.91,
            holdingsCount: 8
        )
        
        let holdings = getDemoHoldings()
        
        return PortfolioHoldingsResponse(
            portfolioSummary: summary,
            holdings: holdings
        )
    }
    
    func getDemoHoldings() -> [Holding] {
        return [
            Holding(
                id: 1,
                stock: Stock(
                    symbol: "AAPL",
                    name: "Apple Inc.",
                    logoUrl: "/static/soulstrader/images/logos/AAPL.png",
                    currentPrice: 175.43,
                    previousClose: 172.88,
                    dayChange: 2.55,
                    dayChangePercent: 1.48,
                    fmpGrade: "A+",
                    currency: "USD",
                    exchange: "NASDAQ",
                    sector: "Technology"
                ),
                quantity: 150,
                averagePrice: 165.20,
                currentValue: 26314.50,
                unrealizedPnl: 1534.50,
                unrealizedPnlPercent: 6.19,
                purchaseDate: Date().addingTimeInterval(-86400 * 45), // 45 days ago
                lastUpdated: Date()
            ),
            Holding(
                id: 2,
                stock: Stock(
                    symbol: "MSFT",
                    name: "Microsoft Corporation",
                    logoUrl: "/static/soulstrader/images/logos/MSFT.png",
                    currentPrice: 378.85,
                    previousClose: 375.20,
                    dayChange: 3.65,
                    dayChangePercent: 0.97,
                    fmpGrade: "A",
                    currency: "USD",
                    exchange: "NASDAQ",
                    sector: "Technology"
                ),
                quantity: 50,
                averagePrice: 350.15,
                currentValue: 18942.50,
                unrealizedPnl: 1435.00,
                unrealizedPnlPercent: 8.20,
                purchaseDate: Date().addingTimeInterval(-86400 * 30), // 30 days ago
                lastUpdated: Date()
            ),
            Holding(
                id: 3,
                stock: Stock(
                    symbol: "TSLA",
                    name: "Tesla, Inc.",
                    logoUrl: "/static/soulstrader/images/logos/TSLA.png",
                    currentPrice: 248.50,
                    previousClose: 252.15,
                    dayChange: -3.65,
                    dayChangePercent: -1.45,
                    fmpGrade: "B",
                    currency: "USD",
                    exchange: "NASDAQ",
                    sector: "Automotive"
                ),
                quantity: 75,
                averagePrice: 265.80,
                currentValue: 18637.50,
                unrealizedPnl: -1297.50,
                unrealizedPnlPercent: -6.50,
                purchaseDate: Date().addingTimeInterval(-86400 * 60), // 60 days ago
                lastUpdated: Date()
            ),
            Holding(
                id: 4,
                stock: Stock(
                    symbol: "NVDA",
                    name: "NVIDIA Corporation",
                    logoUrl: "/static/soulstrader/images/logos/NVDA.png",
                    currentPrice: 875.28,
                    previousClose: 889.45,
                    dayChange: -14.17,
                    dayChangePercent: -1.59,
                    fmpGrade: "A-",
                    currency: "USD",
                    exchange: "NASDAQ",
                    sector: "Technology"
                ),
                quantity: 20,
                averagePrice: 820.50,
                currentValue: 17505.60,
                unrealizedPnl: 1095.60,
                unrealizedPnlPercent: 6.67,
                purchaseDate: Date().addingTimeInterval(-86400 * 15), // 15 days ago
                lastUpdated: Date()
            ),
            Holding(
                id: 5,
                stock: Stock(
                    symbol: "GOOGL",
                    name: "Alphabet Inc.",
                    logoUrl: "/static/soulstrader/images/logos/GOOGL.png",
                    currentPrice: 142.85,
                    previousClose: 140.20,
                    dayChange: 2.65,
                    dayChangePercent: 1.89,
                    fmpGrade: "A",
                    currency: "USD",
                    exchange: "NASDAQ",
                    sector: "Technology"
                ),
                quantity: 100,
                averagePrice: 138.90,
                currentValue: 14285.00,
                unrealizedPnl: 395.00,
                unrealizedPnlPercent: 2.84,
                purchaseDate: Date().addingTimeInterval(-86400 * 25), // 25 days ago
                lastUpdated: Date()
            ),
            Holding(
                id: 6,
                stock: Stock(
                    symbol: "AMZN",
                    name: "Amazon.com, Inc.",
                    logoUrl: "/static/soulstrader/images/logos/AMZN.png",
                    currentPrice: 155.75,
                    previousClose: 153.20,
                    dayChange: 2.55,
                    dayChangePercent: 1.66,
                    fmpGrade: "A-",
                    currency: "USD",
                    exchange: "NASDAQ",
                    sector: "Consumer Discretionary"
                ),
                quantity: 80,
                averagePrice: 148.50,
                currentValue: 12460.00,
                unrealizedPnl: 580.00,
                unrealizedPnlPercent: 4.88,
                purchaseDate: Date().addingTimeInterval(-86400 * 40), // 40 days ago
                lastUpdated: Date()
            ),
            Holding(
                id: 7,
                stock: Stock(
                    symbol: "META",
                    name: "Meta Platforms, Inc.",
                    logoUrl: "/static/soulstrader/images/logos/META.png",
                    currentPrice: 485.20,
                    previousClose: 478.85,
                    dayChange: 6.35,
                    dayChangePercent: 1.33,
                    fmpGrade: "A",
                    currency: "USD",
                    exchange: "NASDAQ",
                    sector: "Technology"
                ),
                quantity: 25,
                averagePrice: 460.80,
                currentValue: 12130.00,
                unrealizedPnl: 610.00,
                unrealizedPnlPercent: 5.30,
                purchaseDate: Date().addingTimeInterval(-86400 * 20), // 20 days ago
                lastUpdated: Date()
            ),
            Holding(
                id: 8,
                stock: Stock(
                    symbol: "BRK.B",
                    name: "Berkshire Hathaway Inc.",
                    logoUrl: "/static/soulstrader/images/logos/BRK.B.png",
                    currentPrice: 368.45,
                    previousClose: 365.20,
                    dayChange: 3.25,
                    dayChangePercent: 0.89,
                    fmpGrade: "A+",
                    currency: "USD",
                    exchange: "NYSE",
                    sector: "Financial Services"
                ),
                quantity: 30,
                averagePrice: 355.75,
                currentValue: 11053.50,
                unrealizedPnl: 381.00,
                unrealizedPnlPercent: 3.56,
                purchaseDate: Date().addingTimeInterval(-86400 * 90), // 90 days ago
                lastUpdated: Date()
            )
        ]
    }
    
    func getDemoTradeSummary() -> TradeSummary {
        return TradeSummary(
            totalValue: 125847.50,
            availableCash: 15420.75,
            totalInvested: 110426.75,
            totalCurrentValue: 115847.50,
            totalUnrealizedPnl: 5420.75,
            totalUnrealizedPnlPercent: 4.91,
            tradesCount: 5,
            sharesCount: 290 // Total shares across all trades
        )
    }
    
    func getDemoTrades() -> TradesResponse {
        let trades = [
            Trade(
                id: "trade_001",
                stock: Stock(
                    symbol: "NVDA",
                    name: "NVIDIA Corporation",
                    logoUrl: "/static/soulstrader/images/logos/NVDA.png",
                    currentPrice: 875.28,
                    previousClose: 889.45,
                    dayChange: -14.17,
                    dayChangePercent: -1.59,
                    fmpGrade: "A-",
                    currency: "USD",
                    exchange: "NASDAQ",
                    sector: "Technology"
                ),
                tradeType: "BUY",
                orderType: "MARKET",
                quantity: 20,
                price: nil,
                averageFillPrice: 820.50,
                totalAmount: 16410.00,
                commission: 9.99,
                status: "FILLED",
                tradeSource: "MOBILE_APP",
                executedAt: Date().addingTimeInterval(-86400 * 15),
                createdAt: Date().addingTimeInterval(-86400 * 15),
                notes: "AI recommendation - Strong buy signal"
            ),
            Trade(
                id: "trade_002",
                stock: Stock(
                    symbol: "META",
                    name: "Meta Platforms, Inc.",
                    logoUrl: "/static/soulstrader/images/logos/META.png",
                    currentPrice: 485.20,
                    previousClose: 478.85,
                    dayChange: 6.35,
                    dayChangePercent: 1.33,
                    fmpGrade: "A",
                    currency: "USD",
                    exchange: "NASDAQ",
                    sector: "Technology"
                ),
                tradeType: "BUY",
                orderType: "LIMIT",
                quantity: 25,
                price: 465.00,
                averageFillPrice: 460.80,
                totalAmount: 11520.00,
                commission: 9.99,
                status: "FILLED",
                tradeSource: "WEB_PLATFORM",
                executedAt: Date().addingTimeInterval(-86400 * 20),
                createdAt: Date().addingTimeInterval(-86400 * 20),
                notes: "Limit order executed below target"
            ),
            Trade(
                id: "trade_003",
                stock: Stock(
                    symbol: "TSLA",
                    name: "Tesla, Inc.",
                    logoUrl: "/static/soulstrader/images/logos/TSLA.png",
                    currentPrice: 248.50,
                    previousClose: 252.15,
                    dayChange: -3.65,
                    dayChangePercent: -1.45,
                    fmpGrade: "B",
                    currency: "USD",
                    exchange: "NASDAQ",
                    sector: "Automotive"
                ),
                tradeType: "BUY",
                orderType: "MARKET",
                quantity: 75,
                price: nil,
                averageFillPrice: 265.80,
                totalAmount: 19935.00,
                commission: 9.99,
                status: "FILLED",
                tradeSource: "MOBILE_APP",
                executedAt: Date().addingTimeInterval(-86400 * 60),
                createdAt: Date().addingTimeInterval(-86400 * 60),
                notes: "Initial position - Long term hold"
            ),
            Trade(
                id: "trade_004",
                stock: Stock(
                    symbol: "AAPL",
                    name: "Apple Inc.",
                    logoUrl: "/static/soulstrader/images/logos/AAPL.png",
                    currentPrice: 175.43,
                    previousClose: 172.88,
                    dayChange: 2.55,
                    dayChangePercent: 1.48,
                    fmpGrade: "A+",
                    currency: "USD",
                    exchange: "NASDAQ",
                    sector: "Technology"
                ),
                tradeType: "BUY",
                orderType: "MARKET",
                quantity: 50,
                price: nil,
                averageFillPrice: 165.20,
                totalAmount: 8260.00,
                commission: 9.99,
                status: "FILLED",
                tradeSource: "WEB_PLATFORM",
                executedAt: Date().addingTimeInterval(-86400 * 45),
                createdAt: Date().addingTimeInterval(-86400 * 45),
                notes: "Dollar cost averaging"
            ),
            Trade(
                id: "trade_005",
                stock: Stock(
                    symbol: "AAPL",
                    name: "Apple Inc.",
                    logoUrl: "/static/soulstrader/images/logos/AAPL.png",
                    currentPrice: 175.43,
                    previousClose: 172.88,
                    dayChange: 2.55,
                    dayChangePercent: 1.48,
                    fmpGrade: "A+",
                    currency: "USD",
                    exchange: "NASDAQ",
                    sector: "Technology"
                ),
                tradeType: "BUY",
                orderType: "MARKET",
                quantity: 100,
                price: nil,
                averageFillPrice: 165.20,
                totalAmount: 16520.00,
                commission: 9.99,
                status: "FILLED",
                tradeSource: "MOBILE_APP",
                executedAt: Date().addingTimeInterval(-86400 * 45),
                createdAt: Date().addingTimeInterval(-86400 * 45),
                notes: "Additional position"
            )
        ]
        
        return TradesResponse(count: trades.count, results: trades)
    }
    
    func getDemoSmartAnalysis() -> SmartAnalysisResponse {
        let session = AnalysisSession(
            id: "1",
            status: "COMPLETED",
            startedAt: Date().addingTimeInterval(-3600), // 1 hour ago
            completedAt: Date().addingTimeInterval(-3540), // 58 minutes ago
            processingTimeSeconds: 58.5,
            totalRecommendations: 5,
            executedRecommendations: 2,
            portfolioValue: 125847.50,
            availableCash: 15420.75
        )
        
        let recommendations = [
            SmartRecommendation(
                id: "1",
                stock: Stock(
                    symbol: "AMD",
                    name: "Advanced Micro Devices, Inc.",
                    logoUrl: "/static/soulstrader/images/logos/AMD.png",
                    currentPrice: 128.45,
                    previousClose: 125.20,
                    dayChange: 3.25,
                    dayChangePercent: 2.60,
                    fmpGrade: "A",
                    currency: "USD",
                    exchange: "NASDAQ",
                    sector: "Technology"
                ),
                recommendationType: "STRONG_BUY",
                priorityScore: 9.2,
                confidenceScore: 0.87,
                sharesToBuy: 75,
                cashAllocated: 9633.75,
                currentPrice: 128.45,
                targetPrice: 145.00,
                stopLoss: 115.00,
                reasoning: "Strong AI chip demand with excellent earnings growth. Market share gains in data center segment.",
                keyFactors: [
                    "AI chip market leader",
                    "Strong Q4 earnings beat",
                    "Growing data center revenue",
                    "Competitive advantage in 5nm technology"
                ],
                riskFactors: [
                    "Competition from NVIDIA",
                    "Market volatility",
                    "Supply chain constraints"
                ],
                status: "ACTIVE",
                createdAt: Date().addingTimeInterval(-3600),
                expiresAt: Date().addingTimeInterval(86400 * 7) // 7 days
            ),
            SmartRecommendation(
                id: "2",
                stock: Stock(
                    symbol: "CRM",
                    name: "Salesforce, Inc.",
                    logoUrl: "/static/soulstrader/images/logos/CRM.png",
                    currentPrice: 245.80,
                    previousClose: 242.15,
                    dayChange: 3.65,
                    dayChangePercent: 1.51,
                    fmpGrade: "A",
                    currency: "USD",
                    exchange: "NYSE",
                    sector: "Technology"
                ),
                recommendationType: "BUY",
                priorityScore: 8.7,
                confidenceScore: 0.82,
                sharesToBuy: 40,
                cashAllocated: 9832.00,
                currentPrice: 245.80,
                targetPrice: 275.00,
                stopLoss: 220.00,
                reasoning: "Leading CRM platform with strong recurring revenue. AI integration driving growth.",
                keyFactors: [
                    "Market leader in CRM",
                    "Strong recurring revenue model",
                    "AI integration with Einstein",
                    "Expanding into new markets"
                ],
                riskFactors: [
                    "High valuation",
                    "Competition from Microsoft",
                    "Economic sensitivity"
                ],
                status: "ACTIVE",
                createdAt: Date().addingTimeInterval(-3600),
                expiresAt: Date().addingTimeInterval(86400 * 5) // 5 days
            ),
            SmartRecommendation(
                id: "3",
                stock: Stock(
                    symbol: "NET",
                    name: "Cloudflare, Inc.",
                    logoUrl: "/static/soulstrader/images/logos/NET.png",
                    currentPrice: 78.25,
                    previousClose: 76.80,
                    dayChange: 1.45,
                    dayChangePercent: 1.89,
                    fmpGrade: "A-",
                    currency: "USD",
                    exchange: "NYSE",
                    sector: "Technology"
                ),
                recommendationType: "BUY",
                priorityScore: 8.1,
                confidenceScore: 0.79,
                sharesToBuy: 125,
                cashAllocated: 9781.25,
                currentPrice: 78.25,
                targetPrice: 95.00,
                stopLoss: 65.00,
                reasoning: "Cloud infrastructure leader with strong growth in edge computing and security.",
                keyFactors: [
                    "Edge computing leader",
                    "Strong security offerings",
                    "Growing enterprise adoption",
                    "Recurring revenue model"
                ],
                riskFactors: [
                    "High growth expectations",
                    "Competition from AWS/Azure",
                    "Market volatility"
                ],
                status: "ACTIVE",
                createdAt: Date().addingTimeInterval(-3600),
                expiresAt: Date().addingTimeInterval(86400 * 10) // 10 days
            ),
            SmartRecommendation(
                id: "4",
                stock: Stock(
                    symbol: "SNOW",
                    name: "Snowflake Inc.",
                    logoUrl: "/static/soulstrader/images/logos/SNOW.png",
                    currentPrice: 185.60,
                    previousClose: 182.45,
                    dayChange: 3.15,
                    dayChangePercent: 1.73,
                    fmpGrade: "A-",
                    currency: "USD",
                    exchange: "NYSE",
                    sector: "Technology"
                ),
                recommendationType: "BUY",
                priorityScore: 7.8,
                confidenceScore: 0.76,
                sharesToBuy: 50,
                cashAllocated: 9280.00,
                currentPrice: 185.60,
                targetPrice: 220.00,
                stopLoss: 160.00,
                reasoning: "Data cloud platform with strong enterprise adoption and AI integration.",
                keyFactors: [
                    "Data cloud leader",
                    "Strong enterprise adoption",
                    "AI/ML integration",
                    "Growing market opportunity"
                ],
                riskFactors: [
                    "High valuation",
                    "Competition from cloud providers",
                    "Customer concentration"
                ],
                status: "ACTIVE",
                createdAt: Date().addingTimeInterval(-3600),
                expiresAt: Date().addingTimeInterval(86400 * 14) // 14 days
            ),
            SmartRecommendation(
                id: "5",
                stock: Stock(
                    symbol: "PLTR",
                    name: "Palantir Technologies Inc.",
                    logoUrl: "/static/soulstrader/images/logos/PLTR.png",
                    currentPrice: 22.85,
                    previousClose: 21.95,
                    dayChange: 0.90,
                    dayChangePercent: 4.10,
                    fmpGrade: "B+",
                    currency: "USD",
                    exchange: "NYSE",
                    sector: "Technology"
                ),
                recommendationType: "BUY",
                priorityScore: 7.2,
                confidenceScore: 0.71,
                sharesToBuy: 400,
                cashAllocated: 9140.00,
                currentPrice: 22.85,
                targetPrice: 28.00,
                stopLoss: 19.00,
                reasoning: "AI analytics platform with strong government and enterprise contracts.",
                keyFactors: [
                    "AI analytics leader",
                    "Strong government contracts",
                    "Growing commercial segment",
                    "Unique data platform"
                ],
                riskFactors: [
                    "Government dependency",
                    "High competition",
                    "Valuation concerns"
                ],
                status: "ACTIVE",
                createdAt: Date().addingTimeInterval(-3600),
                expiresAt: Date().addingTimeInterval(86400 * 21) // 21 days
            )
        ]
        
        return SmartAnalysisResponse(
            latestSession: session,
            recommendations: recommendations,
            message: nil
        )
    }
    
    func getDemoTradeAnalysis() -> TradeAnalysisResponse {
        let trade = TradeAnalysisTrade(
            id: "demo-trade-id",
            stock: TradeAnalysisStock(
                symbol: "GOOGL",
                name: "Alphabet Inc.",
                logoUrl: "/static/soulstrader/images/logos/GOOGL.png",
                currentPrice: 150.25
            ),
            tradeType: "BUY",
            quantity: 25,
            totalAmount: 2500.0,
            executedAt: Date().addingTimeInterval(-3600),
            tradeSource: "SMART_ANALYSIS"
        )
        
        let advisorRecommendations = [
            AdvisorRecommendation(
                advisorName: "Yahoo Finance Enhanced",
                recommendationType: "BUY",
                confidenceScore: 0.87,
                reasoning: "Strong technical indicators suggest upward momentum with positive earnings growth expected",
                targetPrice: 180.0
            ),
            AdvisorRecommendation(
                advisorName: "Finnhub Market Intelligence",
                recommendationType: "BUY",
                confidenceScore: 0.82,
                reasoning: "Positive earnings growth expected with strong analyst consensus",
                targetPrice: 175.0
            ),
            AdvisorRecommendation(
                advisorName: "FMP",
                recommendationType: "STRONG_BUY",
                confidenceScore: 0.91,
                reasoning: "Analyst consensus rating: BUY with strong fundamental metrics",
                targetPrice: 185.0
            ),
            AdvisorRecommendation(
                advisorName: "Google Gemini",
                recommendationType: "BUY",
                confidenceScore: 0.79,
                reasoning: "Strong fundamentals and market position with AI leadership",
                targetPrice: 170.0
            )
        ]
        
        let algorithmSteps = [
            "Stock GOOGL chosen for consideration from market movers",
            "4 advisors gave combined confidence score of 0.87",
            "$2,500 allocated to buy 25 shares based on confidence"
        ]
        
        let technicalDetails = TechnicalDetails(
            priorityScore: 85.0,
            confidenceScore: 0.87,
            recommendationType: "BUY",
            currentPrice: 150.25,
            targetPrice: 180.0,
            stopLoss: 120.0,
            keyFactors: [
                "Strong earnings growth",
                "Positive analyst ratings",
                "AI leadership position",
                "Strong balance sheet"
            ],
            riskFactors: [
                "Market volatility",
                "Regulatory concerns",
                "Competition in AI space"
            ],
            reasoning: "Consolidated analysis from multiple AI advisors showing strong buy signal with high confidence"
        )
        
        return TradeAnalysisResponse(
            trade: trade,
            advisorRecommendations: advisorRecommendations,
            algorithmSteps: algorithmSteps,
            technicalDetails: technicalDetails
        )
    }
}


//
//  APIService.swift
//  SoulTrader
//
//  Created on 2025-09-30
//

import Foundation

@MainActor
class APIService: ObservableObject {
    static let shared = APIService()
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isDemoMode = false
    
    private let baseURL = "http://192.168.1.6:8000/api"
    private var accessToken: String? {
        didSet {
            isAuthenticated = accessToken != nil
        }
    }
    
    private init() {
        // Configure JSON decoder for dates
        setupJSONDecoder()
    }
    
    private let jsonDecoder = JSONDecoder()
    
    private func setupJSONDecoder() {
        // Custom date decoding strategy to handle Django's date formats
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        jsonDecoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            // Try multiple date formats
            let formatters: [DateFormatter] = [
                // Django format with microseconds: 2025-09-30T13:42:03.180349+00:00
                {
                    let f = DateFormatter()
                    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
                    f.locale = Locale(identifier: "en_US_POSIX")
                    f.timeZone = TimeZone(secondsFromGMT: 0)
                    return f
                }(),
                // ISO8601 with fractional seconds: 2025-09-30T13:42:03.180Z
                {
                    let f = DateFormatter()
                    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    f.locale = Locale(identifier: "en_US_POSIX")
                    f.timeZone = TimeZone(secondsFromGMT: 0)
                    return f
                }(),
                // Standard ISO8601: 2025-09-30T13:42:03Z
                {
                    let f = DateFormatter()
                    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    f.locale = Locale(identifier: "en_US_POSIX")
                    f.timeZone = TimeZone(secondsFromGMT: 0)
                    return f
                }(),
                // Without timezone: 2025-09-30T13:42:03
                {
                    let f = DateFormatter()
                    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    f.locale = Locale(identifier: "en_US_POSIX")
                    f.timeZone = TimeZone(secondsFromGMT: 0)
                    return f
                }()
            ]
            
            for formatter in formatters {
                if let date = formatter.date(from: dateString) {
                    return date
                }
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string: \(dateString)"
            )
        }
    }
    
    // MARK: - Authentication
    
    func login(username: String, password: String) async throws -> LoginResponse {
        // Check for demo mode
        if username.lowercased() == "demo" && password.lowercased() == "demo" {
            return enableDemoMode()
        }
        
        let url = URL(string: "\(baseURL)/auth/login/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["username": username, "password": password]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let loginResponse = try jsonDecoder.decode(LoginResponse.self, from: data)
        
        // Store token and user
        self.accessToken = loginResponse.access
        self.currentUser = loginResponse.user
        self.isDemoMode = false
        
        // Store credentials securely for auto-login
        _ = KeychainService.shared.saveCredentials(username: username, password: password)
        
        return loginResponse
    }
    
    // MARK: - Auto Login
    
    func attemptAutoLogin() async -> Bool {
        guard let credentials = KeychainService.shared.loadCredentials() else {
            return false
        }
        
        do {
            // Use the stored credentials to login (but don't save them again)
            let url = URL(string: "\(baseURL)/auth/login/")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = ["username": credentials.username, "password": credentials.password]
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }
            
            let loginResponse = try jsonDecoder.decode(LoginResponse.self, from: data)
            
            // Store token and user (credentials already saved)
            self.accessToken = loginResponse.access
            self.currentUser = loginResponse.user
            self.isDemoMode = false
            
            return true
        } catch {
            // Auto-login failed, clear stored credentials
            KeychainService.shared.deleteCredentials()
            return false
        }
    }
    
    private func enableDemoMode() -> LoginResponse {
        let demoResponse = DemoService.shared.getDemoLoginResponse()
        self.isDemoMode = true
        self.isAuthenticated = true
        self.currentUser = demoResponse.user
        return demoResponse
    }
    
    func logout() {
        accessToken = nil
        currentUser = nil
        isDemoMode = false
        
        // Clear stored credentials
        KeychainService.shared.deleteCredentials()
    }
    
    // MARK: - Portfolio API
    
    func getPortfolioHoldings() async throws -> PortfolioHoldingsResponse {
        if isDemoMode {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            return DemoService.shared.getDemoPortfolioHoldings()
        }
        
        return try await authenticatedRequest(
            endpoint: "/portfolio/holdings/",
            type: PortfolioHoldingsResponse.self
        )
    }
    
    func getPortfolioSummary() async throws -> PortfolioSummary {
        if isDemoMode {
            try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
            return DemoService.shared.getDemoPortfolioHoldings().portfolioSummary
        }
        
        return try await authenticatedRequest(
            endpoint: "/portfolio/summary/",
            type: PortfolioSummary.self
        )
    }
    
    // MARK: - Trades API
    
    func getRecentTrades(limit: Int = 20) async throws -> TradesResponse {
        if isDemoMode {
            try await Task.sleep(nanoseconds: 400_000_000) // 0.4 seconds
            return DemoService.shared.getDemoTrades()
        }
        
        return try await authenticatedRequest(
            endpoint: "/trades/recent/?limit=\(limit)",
            type: TradesResponse.self
        )
    }
    
    func getTradeSummary() async throws -> TradeSummary {
        if isDemoMode {
            try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
            return DemoService.shared.getDemoTradeSummary()
        }
        
        return try await authenticatedRequest(
            endpoint: "/trades/summary/",
            type: TradeSummary.self
        )
    }
    
    func getTradesForStock(symbol: String) async throws -> StockTradesResponse {
        if isDemoMode {
            try await Task.sleep(nanoseconds: 400_000_000) // 0.4 seconds
            // Filter demo trades by symbol
            let allTrades = DemoService.shared.getDemoTrades()
            let filteredTrades = allTrades.results.filter { $0.stock.symbol == symbol.uppercased() }
            return StockTradesResponse(
                symbol: symbol.uppercased(),
                count: filteredTrades.count,
                trades: filteredTrades
            )
        }
        
        return try await authenticatedRequest(
            endpoint: "/trades/stock/\(symbol)/",
            type: StockTradesResponse.self
        )
    }
    
    // MARK: - Smart Analysis API
    
    func getSmartAnalysis() async throws -> SmartAnalysisResponse {
        if isDemoMode {
            try await Task.sleep(nanoseconds: 800_000_000) // 0.8 seconds
            return DemoService.shared.getDemoSmartAnalysis()
        }
        
        return try await authenticatedRequest(
            endpoint: "/analysis/smart/",
            type: SmartAnalysisResponse.self
        )
    }
    
    func getTradeAnalysis(tradeId: String) async throws -> TradeAnalysisResponse {
        if isDemoMode {
            try await Task.sleep(nanoseconds: 600_000_000) // 0.6 seconds
            return DemoService.shared.getMockTradeAnalysis()
        }
        
        return try await authenticatedRequest(
            endpoint: "/analysis/trade/\(tradeId)/",
            type: TradeAnalysisResponse.self
        )
    }
    
    // MARK: - Helper Methods
    
    private func authenticatedRequest<T: Decodable>(
        endpoint: String,
        type: T.Type
    ) async throws -> T {
        guard let token = accessToken else {
            throw APIError.notAuthenticated
        }
        
        let url = URL(string: "\(baseURL)\(endpoint)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw APIError.serverError("HTTP \(statusCode)")
        }
        
        return try jsonDecoder.decode(T.self, from: data)
    }
}

// MARK: - Error Types

enum APIError: LocalizedError {
    case notAuthenticated
    case invalidResponse
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Not authenticated. Please login."
        case .invalidResponse:
            return "Invalid server response"
        case .serverError(let message):
            return "Server error: \(message)"
        }
    }
}

//
//  User.swift
//  SoulTrader
//
//  Created on 2025-09-30
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let profile: UserProfile?
    
    enum CodingKeys: String, CodingKey {
        case id, username, email, profile
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

struct UserProfile: Codable {
    let riskLevel: String
    let investmentGoal: String
    let timeHorizon: String
    let maxPositions: Int
    let esgFocused: Bool
    
    enum CodingKeys: String, CodingKey {
        case riskLevel = "risk_level"
        case investmentGoal = "investment_goal"
        case timeHorizon = "time_horizon"
        case maxPositions = "max_positions"
        case esgFocused = "esg_focused"
    }
}

struct LoginResponse: Codable {
    let access: String
    let refresh: String
    let user: User
}


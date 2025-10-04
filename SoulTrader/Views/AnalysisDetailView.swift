//
//  AnalysisDetailView.swift
//  SoulTrader
//
//  Created on 2025-01-02
//

import SwiftUI

struct AnalysisDetailView: View {
    let trade: Trade
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 12) {
                    HStack {
                        // Stock logo
                        AsyncImage(url: URL(string: buildLogoURL(trade.stock.logoUrl))) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Circle()
                                .fill(Color.purple.opacity(0.2))
                                .overlay(
                                    Text(trade.stock.symbol.prefix(2))
                                        .font(.caption)
                                        .fontWeight(.bold)
                                )
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(trade.stock.symbol)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(trade.stock.name)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    // Trade summary
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Trade Type")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(trade.tradeType)
                                .font(.headline)
                                .foregroundColor(trade.tradeType == "BUY" ? .green : .red)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Quantity")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(trade.quantity) shares")
                                .font(.headline)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Total Amount")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("$\(trade.totalAmount, specifier: "%.2f")")
                                .font(.headline)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding()
                
                // Analysis Details Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Smart Analysis Details")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // Placeholder content
                    VStack(spacing: 12) {
                        AnalysisDetailCard(
                            title: "Recommendation Source",
                            value: trade.tradeSource == "SMART_ANALYSIS" ? "Smart Analysis Engine" : "Manual Trade",
                            icon: "brain.head.profile"
                        )
                        
                        if trade.tradeSource == "SMART_ANALYSIS" {
                            AnalysisDetailCard(
                                title: "Analysis Status",
                                value: "Executed",
                                icon: "checkmark.circle.fill"
                            )
                            
                            AnalysisDetailCard(
                                title: "Execution Date",
                                value: trade.executedAt?.formatted(date: .abbreviated, time: .omitted) ?? "N/A",
                                icon: "calendar"
                            )
                        }
                        
                        if let notes = trade.notes, !notes.isEmpty {
                            AnalysisDetailCard(
                                title: "Trade Notes",
                                value: notes,
                                icon: "note.text"
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Detailed Analysis Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Detailed Analysis")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    if trade.tradeSource == "SMART_ANALYSIS" {
                        VStack(spacing: 12) {
                            // Analysis Reasoning
                            if let notes = trade.notes, !notes.isEmpty {
                                AnalysisDetailCard(
                                    title: "Analysis Reasoning",
                                    value: notes,
                                    icon: "brain.head.profile"
                                )
                            }
                            
                            // Trade Execution Details
                            AnalysisDetailCard(
                                title: "Execution Price",
                                value: trade.averageFillPrice != nil ? String(format: "$%.2f", trade.averageFillPrice!) : "Market Price",
                                icon: "dollarsign.circle"
                            )
                            
                            AnalysisDetailCard(
                                title: "Order Type",
                                value: trade.orderType.replacingOccurrences(of: "_", with: " "),
                                icon: "list.bullet"
                            )
                            
                            // Performance Metrics
                            if let executedAt = trade.executedAt {
                                AnalysisDetailCard(
                                    title: "Execution Time",
                                    value: executedAt.formatted(date: .abbreviated, time: .shortened),
                                    icon: "clock"
                                )
                            }
                            
                            // Commission Information
                            if trade.commission > 0 {
                                AnalysisDetailCard(
                                    title: "Commission",
                                    value: String(format: "$%.2f", trade.commission),
                                    icon: "percent"
                                )
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        // Manual trade analysis
                        VStack(spacing: 12) {
                            AnalysisDetailCard(
                                title: "Trade Type",
                                value: "Manual Trade",
                                icon: "hand.point.up"
                            )
                            
                            AnalysisDetailCard(
                                title: "Execution Method",
                                value: trade.orderType.replacingOccurrences(of: "_", with: " "),
                                icon: "list.bullet"
                            )
                            
                            if let notes = trade.notes, !notes.isEmpty {
                                AnalysisDetailCard(
                                    title: "Trade Notes",
                                    value: notes,
                                    icon: "note.text"
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer(minLength: 50)
            }
        }
        .navigationTitle("Analysis Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("ANALYSIS")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.purple)
            }
        }
    }
}

// MARK: - Analysis Detail Card

struct AnalysisDetailCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.purple)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}

// MARK: - Helper Functions

private func buildLogoURL(_ logoUrl: String?) -> String {
    guard let logoUrl = logoUrl, !logoUrl.isEmpty else {
        return ""
    }
    
    // If it's already a full URL, return it
    if logoUrl.hasPrefix("http") {
        return logoUrl
    }
    
    // If it's a relative path, make it absolute
    if logoUrl.hasPrefix("/static/") {
        return "http://192.168.1.6:8000\(logoUrl)"
    }
    
    // Default fallback
    return logoUrl
}

#Preview {
    NavigationView {
        AnalysisDetailView(trade: Trade(
            id: "1",
            stock: Stock(
                symbol: "AAPL",
                name: "Apple Inc.",
                logoUrl: nil,
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
            quantity: 150,
            price: 175.43,
            averageFillPrice: 175.43,
            totalAmount: 26314.50,
            commission: 0.00,
            status: "FILLED",
            tradeSource: "SMART_ANALYSIS",
            executedAt: Date(),
            createdAt: Date(),
            notes: "Smart analysis recommendation based on strong fundamentals and technical indicators."
        ))
    }
}

//
//  AnalysisView.swift
//  SoulTrader
//
//  Created on 2025-09-30
//

import SwiftUI

struct AnalysisView: View {
    @StateObject private var viewModel = AnalysisViewModel()
    
    var body: some View {
    
        ScrollView {
            VStack(spacing: 16) {
                // Session Summary
                if let session = viewModel.session {
                    SessionSummaryCard(session: session)
                }
                
                // Recommendations
                if !viewModel.recommendations.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recommendations")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(viewModel.recommendations) { rec in
                            StockRow.recommendationRow(recommendation: rec)
                        }
                    }
                } else if !viewModel.isLoading {
                    Text("No recommendations available")
                        .foregroundColor(.secondary)
                        .padding()
                }
                
                // Error message
                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("ANALYSIS")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("ANALYSIS")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.purple)
            }
        }
        .refreshable {
            await viewModel.loadData()
        }
        .task {
            await viewModel.loadData()
        }
    }
}

// MARK: - Session Summary Card

struct SessionSummaryCard: View {
    let session: AnalysisSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Latest Analysis")
                    .font(.headline)
                Spacer()
                Text(session.status)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(session.status == "COMPLETED" ? Color.green : Color.orange)
                    .cornerRadius(4)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recommendations")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(session.totalRecommendations)")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Processing Time")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(session.processingTimeSeconds ?? 0, specifier: "%.1f")s")
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}


#Preview {
    AnalysisView()
}

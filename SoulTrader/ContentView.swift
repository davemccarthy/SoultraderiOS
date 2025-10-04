//
//  ContentView.swift
//  SoulTrader
//
//  Created by David McCarthy on 01/10/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var apiService = APIService.shared
    @State private var selectedTab = 0
    @State private var showingLogin = true
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggingIn = false
    @State private var loginError: String?
    
    var body: some View {
        if apiService.isAuthenticated {
            // Main Tab View
            TabView(selection: $selectedTab) {
                // Tab 1: Portfolio
                PortfolioView()
                    .tabItem {
                        Label("Portfolio", systemImage: "chart.pie.fill")
                    }
                    .tag(0)
                
                // Tab 2: Trades (with integrated analysis)
                TradeView()
                    .tabItem {
                        Label("Trades", systemImage: "arrow.left.arrow.right")
                    }
                    .tag(1)
            }
            .accentColor(.purple)
        } else {
            // Login View
            VStack(spacing: 24) {
                // Logo/Title
                VStack(spacing: 8) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.purple)
                    
                    Text("SOULTRADER")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.purple)
                    
                    Text("AI Stock Advisor")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 60)
                
                // Login Form
                VStack(spacing: 16) {
                    TextField("Username", text: $username)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                    
                    if let error = loginError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    Button(action: login) {
                        if isLoggingIn {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.white)
                        } else {
                            Text("Login")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(isLoggingIn)
                    
                    // Demo Mode Button
                    Button(action: loginDemo) {
                        HStack(spacing: 8) {
                            Image(systemName: "play.circle.fill")
                            Text("Try Demo Mode")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                    }
                    .disabled(isLoggingIn)
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Footer
                Text("Secure JWT Authentication")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            }
        }
    }
    
    private func login() {
        isLoggingIn = true
        loginError = nil
        
        Task {
            do {
                _ = try await apiService.login(username: username, password: password)
                // Success - apiService.isAuthenticated will trigger view update
            } catch {
                loginError = error.localizedDescription
            }
            isLoggingIn = false
        }
    }
    
    private func loginDemo() {
        isLoggingIn = true
        loginError = nil
        
        Task {
            do {
                _ = try await apiService.login(username: "demo", password: "demo")
                // Success - apiService.isAuthenticated will trigger view update
            } catch {
                loginError = error.localizedDescription
            }
            isLoggingIn = false
        }
    }
}


#Preview {
    ContentView()
}

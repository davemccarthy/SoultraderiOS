//
//  KeychainService.swift
//  SoulTrader
//
//  Secure credential storage using iOS Keychain
//

import Foundation
import Security

class KeychainService {
    static let shared = KeychainService()
    
    private let service = "com.soultrader.credentials"
    private let usernameKey = "username"
    private let passwordKey = "password"
    
    private init() {}
    
    // MARK: - Save Credentials
    
    func saveCredentials(username: String, password: String) -> Bool {
        // Delete existing credentials first
        deleteCredentials()
        
        // Save username
        let usernameData = username.data(using: .utf8)!
        let usernameQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: usernameKey,
            kSecValueData as String: usernameData
        ]
        
        let usernameStatus = SecItemAdd(usernameQuery as CFDictionary, nil)
        
        // Save password
        let passwordData = password.data(using: .utf8)!
        let passwordQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: passwordKey,
            kSecValueData as String: passwordData
        ]
        
        let passwordStatus = SecItemAdd(passwordQuery as CFDictionary, nil)
        
        return usernameStatus == errSecSuccess && passwordStatus == errSecSuccess
    }
    
    // MARK: - Load Credentials
    
    func loadCredentials() -> (username: String, password: String)? {
        guard let username = loadString(for: usernameKey),
              let password = loadString(for: passwordKey) else {
            return nil
        }
        
        return (username: username, password: password)
    }
    
    private func loadString(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return string
    }
    
    // MARK: - Delete Credentials
    
    func deleteCredentials() {
        deleteItem(for: usernameKey)
        deleteItem(for: passwordKey)
    }
    
    private func deleteItem(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    // MARK: - Check if credentials exist
    
    func hasStoredCredentials() -> Bool {
        return loadCredentials() != nil
    }
}

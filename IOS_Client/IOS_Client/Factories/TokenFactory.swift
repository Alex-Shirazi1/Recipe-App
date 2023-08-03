//
//  TokenFactory.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 8/2/23.
//

import Foundation
import KeychainSwift

/// Used to manage app token for login and authentication, should be singleton
class TokenFactory {
    
    /// token instance for entire app
    static let appToken = TokenFactory()
    
    private let keychain = KeychainSwift()
    
    /// Login
    func setToken(token: String) {
        keychain.set(token, forKey: "userToken")
    }
    
    /// Using login, if nil, then user is not logged in
    func getToken() -> String? {
        return keychain.get("userToken")
    }
    
    /// Logout
    
    func destroyToken() {
        keychain.delete("userToken")
        keychain.delete("username")
    }

    /// Simply checks if user is logged in for some areas that dont need token
    func isLoggedIn() -> Bool {
        return getToken() != nil
    }
    
    /// Fetching and Setting Username
    
    func setUsername(username: String) {
        keychain.set(username, forKey: "username")
    }
    func getUsername() -> String? {
        return keychain.get("username")
    }
    
    
}

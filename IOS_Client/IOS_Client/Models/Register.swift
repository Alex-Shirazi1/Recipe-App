//
//  Register.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 8/3/23.
//

import Foundation

struct Register: Codable {
    let username: String
    let email: String
    let password: String
    let isAdmin: Bool
    
    
    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
        self.isAdmin = false
    }
    
    
}

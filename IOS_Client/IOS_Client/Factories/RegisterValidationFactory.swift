//
//  RegisterValidationFactory.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 8/3/23.
//

import Foundation


protocol RegisterValidationFactoryType {
    func validateUsername(username: String) -> ValidationError?
    func validatePassword(password: String) -> ValidationError?
    func validateEmail(email: String) -> ValidationError?
    
    func emailMongoValidation(email: String, completion: @escaping (Result<Void, ValidationError>) -> Void)
    func usernameMongoValidation(username: String, completion: @escaping (Result<Void, ValidationError>) -> Void)
}

class RegisterValidationFactory: RegisterValidationFactoryType {
    
    
    // Check if the username length is between 4 and 20 characters
    func validateUsername(username: String) -> ValidationError? {
        guard username.count >= 4 && username.count <= 20 else {
            return .usernameInvalidLength
        }
        return nil
    }
    
    // Check if the password length is between 4 and 20 characters
    func validatePassword(password: String) -> ValidationError? {
        guard password.count >= 4 && password.count <= 20 else {
            return .passwordInvalidLength
        }
        return nil
    }
    
    // Frontend Email Validation
    func validateEmail(email: String) -> ValidationError? {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", pattern)
        if !predicate.evaluate(with: email) {
            return .emailInvalidFormat
        }
        return nil
    }
    
    func emailMongoValidation(email: String, completion: @escaping (Result<Void, ValidationError>) -> Void) {
        guard let url = URL(string: MainConfig.serverAddress + "/emailExists/" + email.lowercased()) else {
            completion(.failure(.emailInvalidFormat))
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to get data from URL: \(error.localizedDescription)")
                completion(.failure(.networkFailure))
                return
            }
            guard let data = data, let result = String(data: data, encoding: .utf8) else {
                completion(.failure(.networkFailure))
                return
            }
            completion(result == "Email already exists" ? .failure(.emailExists) : .success(()))
        }.resume()
    }
    
    func usernameMongoValidation(username: String, completion: @escaping (Result<Void, ValidationError>) -> Void) {
        guard let url = URL(string: MainConfig.serverAddress + "/usernameExists/" + username.lowercased()) else {
            completion(.failure(.usernameInvalidLength))
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to get data from URL: \(error.localizedDescription)")
                completion(.failure(.networkFailure))
                return
            }
            guard let data = data, let result = String(data: data, encoding: .utf8) else {
                completion(.failure(.networkFailure))
                return
            }
            completion(result == "Username already exists" ? .failure(.usernameExists) : .success(()))
        }.resume()
    }
    
    
}

enum ValidationError: Error {
    case usernameInvalidLength
    case passwordInvalidLength
    case emailInvalidFormat
    case usernameExists
    case emailExists
    case networkFailure
    
    var localizedDescription: String {
        switch self {
        case .usernameInvalidLength:
            return "Username must be between 4 and 20 characters long."
        case .passwordInvalidLength:
            return "Password must be between 4 and 20 characters long."
        case .emailInvalidFormat:
            return "Email format is invalid."
        case .usernameExists:
            return "Username already exists."
        case .emailExists:
            return "Email already exists."
        case .networkFailure:
            return "Network failure occurred."
        }
    }
}

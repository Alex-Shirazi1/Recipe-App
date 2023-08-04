//
//  RegisterInteractor.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation

protocol RegisterInteractorProtocol: AnyObject {
   func registerUser(registerDetails: Register, completion: @escaping (Result<String?, Error>) -> Void)
}

class RegisterInteractor: RegisterInteractorProtocol {
    let dataManager: RegisterDataManagerProtocol
    let registerValidationFactory: RegisterValidationFactoryType
    
    init(dataManager: RegisterDataManagerProtocol = RegisterDataManager(), registerValidationFactory: RegisterValidationFactoryType = RegisterValidationFactory()) {
        self.dataManager = dataManager
        self.registerValidationFactory = registerValidationFactory
    }
    
    func registerUser(registerDetails: Register, completion: @escaping (Result<String?, Error>) -> Void) {
        // Frontend validation for email, username, and password
        if let emailValidationError = registerValidationFactory.validateEmail(email: registerDetails.email),
           let usernameValidationError = registerValidationFactory.validateUsername(username: registerDetails.username),
           let passwordValidationError = registerValidationFactory.validatePassword(password: registerDetails.password) {
            
            // return the first occurred error
            let error = emailValidationError ?? usernameValidationError ?? passwordValidationError
            completion(.failure(error))
            return
        }
        
        let group = DispatchGroup()
        var emailValidationError: Error?
        var usernameValidationError: Error?
        
        group.enter()
        registerValidationFactory.emailMongoValidation(email: registerDetails.email) { (result) in
            if case .failure(let error) = result {
                emailValidationError = error
            }
            group.leave()
        }
        
        group.enter()
        registerValidationFactory.usernameMongoValidation(username: registerDetails.username) { (result) in
            if case .failure(let error) = result {
                usernameValidationError = error
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let error = emailValidationError ?? usernameValidationError {
                completion(.failure(error))
            } else {
                // Here all validations have passed and we can proceed with registration
                self.dataManager.proceedRegister(registerDetails: registerDetails, completion: completion)
            }
        }
    }
}

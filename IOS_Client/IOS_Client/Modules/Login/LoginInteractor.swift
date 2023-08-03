//
//  LoginInteractor.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation

protocol LoginInteractorProtocol: AnyObject {
    func proceedLogin(login: Login, completion: @escaping (Error?) -> Void)
}

class LoginInteractor: LoginInteractorProtocol {
    let dataManager: LoginDataManagerProtocol
    
    init(dataManager: LoginDataManagerProtocol = LoginDataManager()) {
        self.dataManager = dataManager
    }
    
        func proceedLogin(login: Login, completion: @escaping (Error?) -> Void) {
            dataManager.proceedLogin(login: login) { token, username, error in
                if let error = error {
                    completion(error)
                    return
                }

                guard let token = token, let username = username else {
                    completion(nil)
                    return
                }

                TokenFactory.appToken.setToken(token: token)
                TokenFactory.appToken.setUsername(username: username)
                print("TF \(TokenFactory.appToken.getUsername())")
                print("\(TokenFactory.appToken.isLoggedIn())")
                
                completion(nil)
            }
        }
    }

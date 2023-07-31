//
//  LoginInteractor.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation

protocol LoginInteractorProtocol: AnyObject {
    func proceedLogin(login: Login, completion: @escaping (Bool) -> Void)
}

class LoginInteractor: LoginInteractorProtocol {
    let dataManager: LoginDataManagerProtocol
    
    init(dataManager: LoginDataManagerProtocol = LoginDataManager()) {
        self.dataManager = dataManager
    }
    
    func proceedLogin(login: Login, completion: @escaping (Bool) -> Void) {
        dataManager.proceedLogin(login: login, completion: completion)
    }
    
}

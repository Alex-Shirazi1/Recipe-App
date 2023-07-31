//
//  RegisterInteractor.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation

protocol RegisterInteractorProtocol: AnyObject {
    
}

class RegisterInteractor: RegisterInteractorProtocol {
    let dataManager: RegisterDataManagerProtocol
    
    init(dataManager: RegisterDataManagerProtocol = RegisterDataManager()) {
        self.dataManager = dataManager
    }
}

//
//  ProfileInteractor.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/28/23.
//

import Foundation

protocol ProfileInteractorProtocol: AnyObject {
    
}

class ProfileInteractor: ProfileInteractorProtocol {
    let dataManager: ProfileDataManagerProtocol
    
    init(dataManager: ProfileDataManagerProtocol = ProfileDataManager()) {
        self.dataManager = dataManager
    }
}

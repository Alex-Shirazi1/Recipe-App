//
//  SettingsInteractor.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/26/23.
//

import Foundation

protocol SettingsInteractorProtocol: AnyObject {
    
}

class SettingsInteractor: SettingsInteractorProtocol {
    let dataManager: SettingsDataManagerProtocol
    
    init(dataManager: SettingsDataManagerProtocol = SettingsDataManager()) {
        self.dataManager = dataManager
    }
}

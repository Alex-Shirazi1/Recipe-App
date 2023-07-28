//
//  CreatePostInteractor.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/28/23.
//

import Foundation

protocol CreatePostInteractorProtocol: AnyObject {
    
}

class CreatePostInteractor: CreatePostInteractorProtocol {
    let dataManager: CreatePostDataManagerProtocol
    
    init(dataManager: CreatePostDataManagerProtocol = CreatePostDataManager()) {
        self.dataManager = dataManager
    }
}

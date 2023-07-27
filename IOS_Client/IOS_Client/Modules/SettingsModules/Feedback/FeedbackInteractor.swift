//
//  FeedbackInteractor.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/26/23.
//

import Foundation

protocol FeedbackInteractorProtocol: AnyObject {
    func sendFeedback(data: FeedbackData)
}

class FeedbackInteractor: FeedbackInteractorProtocol {
    let dataManager: FeedbackDataManagerProtocol

    init(dataManager: FeedbackDataManagerProtocol = FeedbackDataManager()) {
        self.dataManager = dataManager
    }
    
    func sendFeedback(data: FeedbackData) {
        dataManager.sendFeedback(data: data)
    }
}

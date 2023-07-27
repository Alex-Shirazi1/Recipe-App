//
//  FeedbackEventHandler.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/26/23.
//

import Foundation

protocol FeedbackEventHandlerProtocol: AnyObject {
    var viewController: FeedbackViewControllerProtocol? { get set }
    
    func sendFeedback(data: FeedbackData)
}

class FeedbackEventHandler: FeedbackEventHandlerProtocol {
    weak var viewController: FeedbackViewControllerProtocol?
    let interactor: FeedbackInteractorProtocol
    let router: FeedbackRouterProtocol

    init(interactor: FeedbackInteractorProtocol, router: FeedbackRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func sendFeedback(data: FeedbackData) {
        interactor.sendFeedback(data: data)
        DispatchQueue.main.async {
            self.viewController?.feedbackSubmitted()
        }
    }
}

//
//  FeedbackRouter.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/26/23.
//

import Foundation
import UIKit

protocol FeedbackRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

class FeedbackRouter: FeedbackRouterProtocol {

    static func createModule() -> UIViewController {
        let interactor: FeedbackInteractorProtocol = FeedbackInteractor()
        let router: FeedbackRouter = FeedbackRouter()
        let eventHandler: FeedbackEventHandlerProtocol = FeedbackEventHandler(interactor: interactor, router: router)
        let viewController = FeedbackViewController(eventHandler: eventHandler)
        eventHandler.viewController = viewController
        return viewController
    }
}

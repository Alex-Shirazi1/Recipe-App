//
//  LoginRouter.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation
import UIKit

protocol LoginRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

class LoginRouter: LoginRouterProtocol {
    static func createModule() -> UIViewController {
        let interactor: LoginInteractorProtocol = LoginInteractor()
        let router: LoginRouter = LoginRouter()

        let eventHandler: LoginEventHandlerProtocol = LoginEventHandler(interactor: interactor, router: router)
        let viewController = LoginViewController(eventHandler: eventHandler)
        eventHandler.viewController = viewController
        return viewController
    }
}

//
//  RegisterRouter.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation
import UIKit

protocol RegisterRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

class RegisterRouter: RegisterRouterProtocol {
   // weak var navigationController: UINavigationController?
    
    static func createModule() -> UIViewController {
        let interactor: RegisterInteractorProtocol = RegisterInteractor()
        let router: RegisterRouter = RegisterRouter()
      //  router.navigationController = navigationController
        let eventHandler: RegisterEventHandlerProtocol = RegisterEventHandler(interactor: interactor, router: router)
        let viewController = RegisterViewController(eventHandler: eventHandler)
        eventHandler.viewController = viewController
        return viewController
    }
}

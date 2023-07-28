//
//  ProfileRouter.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/28/23.
//

import Foundation
import UIKit

protocol ProfileRouterProtocol: AnyObject {
    static func createModule(navigationController: UINavigationController) -> UIViewController
}

class ProfileRouter: ProfileRouterProtocol {
    weak var navigationController: UINavigationController?
    
    static func createModule(navigationController: UINavigationController) -> UIViewController {
        let interactor: ProfileInteractorProtocol = ProfileInteractor()
        let router: ProfileRouter = ProfileRouter()
        router.navigationController = navigationController
        let eventHandler: ProfileEventHandlerProtocol = ProfileEventHandler(interactor: interactor, router: router)
        let viewController = ProfileViewController(eventHandler: eventHandler)
        eventHandler.viewController = viewController
        return viewController
    }
}

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
    
    func navigateToLoginModule(profileViewController: ProfileViewControllerProtocol)
    
    func navigateToRegisterModule(profileViewController: ProfileViewControllerProtocol)
}

class ProfileRouter: ProfileRouterProtocol {
    weak var navigationController: UINavigationController?
    
    static func createModule(navigationController: UINavigationController) -> UIViewController {
        let interactor: ProfileInteractorProtocol = ProfileInteractor()
        let router: ProfileRouter = ProfileRouter()
        router.navigationController = navigationController
        let eventHandler: ProfileEventHandlerProtocol = ProfileEventHandler(interactor: interactor, router: router)
        let viewController = ProfileViewController(eventHandler: eventHandler, tableViewCellFactory: TableViewCellFactory())
        eventHandler.viewController = viewController
        return viewController
    }
    
    func navigateToLoginModule(profileViewController: ProfileViewControllerProtocol) {
        guard let navigationController else {
            return
        }
        let loginModule = LoginRouter.createModule(navigationController: navigationController, profileViewController: profileViewController)
        navigationController.pushViewController(loginModule, animated: true)
    }
    
    func navigateToRegisterModule(profileViewController: ProfileViewControllerProtocol) {
        
        
        guard let navigationController else {
            return
        }
        let registerModule = RegisterRouter.createModule(navigationController: navigationController, profileViewController: profileViewController)
        navigationController.pushViewController(registerModule, animated: true)
    }
    }


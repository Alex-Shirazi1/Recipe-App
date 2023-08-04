//
//  RegisterRouter.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation
import UIKit

protocol RegisterRouterProtocol: AnyObject {
    static func createModule(navigationController: UINavigationController, profileViewController: ProfileViewControllerProtocol) -> UIViewController
    
    func navigateToLogin()
}

class RegisterRouter: RegisterRouterProtocol {
    
    var navigationController: UINavigationController
    
    let profileViewController: ProfileViewControllerProtocol
    
    init(navigationController: UINavigationController, profileViewController: ProfileViewControllerProtocol) {
        self.navigationController = navigationController
        self.profileViewController = profileViewController
    }
    
    static func createModule(navigationController navigationViewController: UINavigationController, profileViewController: ProfileViewControllerProtocol) -> UIViewController {
        
        let interactor: RegisterInteractorProtocol = RegisterInteractor()
        let router: RegisterRouter = RegisterRouter(navigationController: navigationViewController, profileViewController: profileViewController)
        let eventHandler: RegisterEventHandlerProtocol = RegisterEventHandler(interactor: interactor, router: router)
        let viewController = RegisterViewController(eventHandler: eventHandler)
        eventHandler.viewController = viewController
        return viewController
    }
    
    func navigateToLogin() {
        DispatchQueue.main.async {
            self.navigationController.popViewController(animated: true)
            self.profileViewController.eventHandler?.loginRoute(profileViewController: self.profileViewController)
            guard let topVC = self.navigationController.viewControllers.last else {
                return
            }
            let banner = BannerViewController(message: "Register Successful")
            banner.presentBanner(from: topVC, withDelay: true)
        }
    }
}

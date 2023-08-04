//
//  LoginRouter.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation
import UIKit

protocol LoginRouterProtocol: AnyObject {
    static func createModule(navigationController: UINavigationController, profileViewController: ProfileViewControllerProtocol) -> UIViewController
    
    func postLogin(loginViewController: LoginViewController, username: String)
}

class LoginRouter: LoginRouterProtocol {
    
    var navigationController: UINavigationController
    
    let profileViewController: ProfileViewControllerProtocol
    
    init(navigationController: UINavigationController, profileViewController: ProfileViewControllerProtocol) {
        self.navigationController = navigationController
        self.profileViewController = profileViewController
    }
    
    static func createModule(navigationController navigationViewController: UINavigationController, profileViewController: ProfileViewControllerProtocol) -> UIViewController {
        
        let interactor: LoginInteractorProtocol = LoginInteractor()
        let router: LoginRouter = LoginRouter(navigationController: navigationViewController, profileViewController: profileViewController)
        let eventHandler: LoginEventHandlerProtocol = LoginEventHandler(interactor: interactor, router: router)
        let viewController = LoginViewController(eventHandler: eventHandler)
        eventHandler.viewController = viewController
        return viewController
    }
    
    func postLogin(loginViewController: LoginViewController, username: String) {
        profileViewController.updateUI()
        navigationController.popViewController(animated: true)
        guard let topVC = navigationController.viewControllers.last else {
            return
        }
            let banner = BannerViewController(message: "Welcome back \(username)!")
            banner.presentBanner(from: topVC, withDelay: true)
    }
}

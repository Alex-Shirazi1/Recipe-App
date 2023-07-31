//
//  LoginRouter.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation
import UIKit

protocol LoginRouterProtocol: AnyObject {
    static func createModule(navigationController: UINavigationController) -> UIViewController
    
    func postLogin(loginViewController: LoginViewController, username: String)
}

class LoginRouter: LoginRouterProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    static func createModule(navigationController navigationViewController: UINavigationController) -> UIViewController {
        
        let interactor: LoginInteractorProtocol = LoginInteractor()
        let router: LoginRouter = LoginRouter(navigationController: navigationViewController)
        let eventHandler: LoginEventHandlerProtocol = LoginEventHandler(interactor: interactor, router: router)
        let viewController = LoginViewController(eventHandler: eventHandler)
        eventHandler.viewController = viewController
        return viewController
    }
    
    func postLogin(loginViewController: LoginViewController, username: String) {
        navigationController.popViewController(animated: true)
        guard let topVC = navigationController.viewControllers.last else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let banner = BannerViewController(message: "Welcome back \(username)!")
            banner.presentBanner(from: topVC)
        }
    }
}

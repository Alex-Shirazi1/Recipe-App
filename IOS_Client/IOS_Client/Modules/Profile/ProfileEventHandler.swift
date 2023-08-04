//
//  ProfileEventHandler.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/28/23.
//

import Foundation


protocol ProfileEventHandlerProtocol: AnyObject {
    var viewController: ProfileViewControllerProtocol? { get set }
    
    func loginRoute(profileViewController: ProfileViewControllerProtocol)
    
    func registerButtonTapped(profileViewController: ProfileViewControllerProtocol)
    
    func handleLogout()
}

class ProfileEventHandler: ProfileEventHandlerProtocol {
    weak var viewController: ProfileViewControllerProtocol?
    
    let interactor: ProfileInteractorProtocol
    let router: ProfileRouterProtocol
    
    init(interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func loginRoute(profileViewController: ProfileViewControllerProtocol) {
        router.navigateToLoginModule(profileViewController: profileViewController)
    }
    
    func registerButtonTapped(profileViewController: ProfileViewControllerProtocol) {
        router.navigateToRegisterModule(profileViewController: profileViewController)
    }
    
    func handleLogout() {
        
        viewController?.updateUI()
    }
}


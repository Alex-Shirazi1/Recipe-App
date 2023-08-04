//
//  RegisterEventHandler.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation


protocol RegisterEventHandlerProtocol: AnyObject {
    var viewController: RegisterViewControllerProtocol? { get set }
    
    func navigateToLogin()
}

class RegisterEventHandler: RegisterEventHandlerProtocol {
    weak var viewController: RegisterViewControllerProtocol?
    
    let interactor: RegisterInteractorProtocol
    let router: RegisterRouterProtocol
    
    init(interactor: RegisterInteractorProtocol, router: RegisterRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func navigateToLogin() {
        router.navigateToLogin()
    }
    
}

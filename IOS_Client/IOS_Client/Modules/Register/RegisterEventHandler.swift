//
//  RegisterEventHandler.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation


protocol RegisterEventHandlerProtocol: AnyObject {
    var viewController: RegisterViewControllerProtocol? { get set }
    
    func registerUser(username: String, email: String, password: String)
    
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
    
    func registerUser(username: String, email: String, password: String) {
        let registerDetails = Register(username: username, email: email, password: password)
        interactor.registerUser(registerDetails: registerDetails) { result in
            switch result {
            case .success(let message):
                print("Registration succeeded: \(message)")
                self.navigateToLogin()
            case .failure(let error):
                print("Registration failed: \(error)")
                self.viewController?.showErrorAlert(error: error)
            }
        }
    }
    
    func navigateToLogin() {
        router.navigateToLogin()
    }
}

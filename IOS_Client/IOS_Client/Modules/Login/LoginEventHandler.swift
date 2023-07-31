//
//  LoginEventHandler.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation


protocol LoginEventHandlerProtocol: AnyObject {
    var viewController: LoginViewControllerProtocol? { get set }
    
    func proceedLogin(login: Login, completion: @escaping (Bool) -> Void)
    
    func postLogin(loginViewController: LoginViewController, username: String)
}

class LoginEventHandler: LoginEventHandlerProtocol {
    weak var viewController: LoginViewControllerProtocol?
    
    let interactor: LoginInteractorProtocol
    let router: LoginRouterProtocol
    
    init(interactor: LoginInteractorProtocol, router: LoginRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func proceedLogin(login: Login, completion: @escaping (Bool) -> Void) {
        interactor.proceedLogin(login: login, completion: completion)
    }
    
    func postLogin(loginViewController: LoginViewController, username: String) {
        router.postLogin(loginViewController: loginViewController, username: username)
    }
}

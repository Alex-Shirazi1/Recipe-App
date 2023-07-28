//
//  ProfileEventHandler.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/28/23.
//

import Foundation


protocol ProfileEventHandlerProtocol: AnyObject {
    var viewController: ProfileViewControllerProtocol? { get set }
}

class ProfileEventHandler: ProfileEventHandlerProtocol {
    weak var viewController: ProfileViewControllerProtocol?
    
    let interactor: ProfileInteractorProtocol
    let router: ProfileRouterProtocol
    
    init(interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
}

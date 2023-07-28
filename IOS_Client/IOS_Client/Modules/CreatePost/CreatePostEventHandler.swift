//
//  CreatePostEventHandler.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/28/23.
//

import Foundation


protocol CreatePostEventHandlerProtocol: AnyObject {
    var viewController: CreatePostViewControllerProtocol? { get set }
}

class CreatePostEventHandler: CreatePostEventHandlerProtocol {
    weak var viewController: CreatePostViewControllerProtocol?
    
    let interactor: CreatePostInteractorProtocol
    let router: CreatePostRouterProtocol
    
    init(interactor: CreatePostInteractorProtocol, router: CreatePostRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
}

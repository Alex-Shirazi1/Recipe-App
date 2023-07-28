//
//  CreatePostRouter.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/28/23.
//

import Foundation
import UIKit

protocol CreatePostRouterProtocol: AnyObject {
    static func createModule(navigationController: UINavigationController) -> UIViewController
}

class CreatePostRouter: CreatePostRouterProtocol {
    weak var navigationController: UINavigationController?
    
    static func createModule(navigationController: UINavigationController) -> UIViewController {
        let interactor: CreatePostInteractorProtocol = CreatePostInteractor()
        let router: CreatePostRouter = CreatePostRouter()
        router.navigationController = navigationController
        let eventHandler: CreatePostEventHandlerProtocol = CreatePostEventHandler(interactor: interactor, router: router)
        let viewController = CreatePostViewController(eventHandler: eventHandler)
        eventHandler.viewController = viewController
        return viewController
    }
}

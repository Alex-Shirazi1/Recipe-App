//
//  HomeRouter.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/14/23.
//

import Foundation
import UIKit

protocol HomeRouterProtocol {
    static func createModule(navigationController: UINavigationController) -> UIViewController
    
    func navigateToPost(post: Post)
}

class HomeRouter: HomeRouterProtocol {
    weak var navigationController: UINavigationController?

    static func createModule(navigationController: UINavigationController) -> UIViewController {
        let interactor: HomeInteractorProtocol = HomeInteractor()
        let router: HomeRouter = HomeRouter()
        router.navigationController = navigationController
        var eventHandler: HomeEventHandlerProtocol = HomeEventHandler(interactor: interactor, router: router)
        let viewController = HomeViewController(eventHandler: eventHandler)
        eventHandler.viewController = viewController
        return viewController
    }

    func navigateToPost(post: Post) {
        let listingModule = ListingRouter.createModule(with: post)
        navigationController?.pushViewController(listingModule, animated: true)
    }
}



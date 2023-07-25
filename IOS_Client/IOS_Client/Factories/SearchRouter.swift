//
//  SearchRouter.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/25/23.
//

import Foundation
import UIKit

protocol SearchRouterProtocol: AnyObject {
    static func createModule(navigationController: UINavigationController) -> UIViewController
    
    func navigateToPost(post: Post)
}

class SearchRouter: SearchRouterProtocol {
    weak var navigationController: UINavigationController?

    static func createModule(navigationController: UINavigationController) -> UIViewController {
        let interactor: SearchInteractorProtocol = SearchInteractor()
        let router: SearchRouter = SearchRouter()
        router.navigationController = navigationController
        let eventHandler: SearchEventHandlerProtocol = SearchEventHandler(interactor: interactor, router: router)
        let viewController = SearchViewController(eventHandler: eventHandler)
        eventHandler.viewController = viewController
        return viewController
    }
    func navigateToPost(post: Post) {
        let listingModule = ListingRouter.createModule(with: post)
        navigationController?.pushViewController(listingModule, animated: true)
    }
}

//
//  HomeRouter.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/14/23.
//

import Foundation
import UIKit

protocol HomeRouterProtocol {
    static func createModule() -> UIViewController
    
    func navigateToPost(post: Post)
}

class HomeRouter: HomeRouterProtocol {
    static func createModule() -> UIViewController {
        let interactor: HomeInteractorProtocol = HomeInteractor()
        let router: HomeRouterProtocol = HomeRouter()
        var eventHandler: HomeEventHandlerProtocol = HomeEventHandler(interactor: interactor, router: router)
        let viewController = HomeViewController(eventHandler: eventHandler)
        eventHandler.viewController = viewController
        return viewController
    }
    
    func navigateToPost(post: Post) {
        let listingModule = ListingRouter.createModule(with: post)
    }
}


//
//  ListingRouter.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/21/23.
//

import Foundation
import UIKit

protocol ListingRouterProtocol {
    static func createModule(with post: Post) -> UIViewController
}

class ListingRouter: ListingRouterProtocol {
    static func createModule(with post: Post) -> UIViewController {
        let interactor: ListingInteractorProtocol = ListingInteractor()
        let router: ListingRouterProtocol = ListingRouter()
        var eventHandler: ListingEventHandlerProtocol = ListingEventHandler(interactor: interactor, router: router)
        let viewController = ListingViewController(eventHandler: eventHandler, post: post)
        eventHandler.viewController = viewController
        return viewController
    }
}

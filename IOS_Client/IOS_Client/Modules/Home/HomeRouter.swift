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
}

class HomeRouter: HomeRouterProtocol {
    static func createModule() -> UIViewController {
        let interactor: HomeInteractorProtocol = HomeInteractor()
        let router: HomeRouterProtocol = HomeRouter()
        let eventHandler: HomeEventHandlerProtocol = HomeEventHandler(interactor: interactor, router: router)
        let viewController = HomeViewController(eventHandler: eventHandler)
        
        return viewController
    }
}

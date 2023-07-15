//
//  HomeEventHandler.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/14/23.
//

import Foundation
import Foundation

protocol HomeEventHandlerProtocol {
    
}

class HomeEventHandler: HomeEventHandlerProtocol {
    weak var viewController: HomeViewControllerProtocol?
    var interactor: HomeInteractorProtocol
    var router: HomeRouterProtocol
    
    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

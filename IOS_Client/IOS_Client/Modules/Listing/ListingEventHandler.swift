//
//  ListingEventHandler.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/21/23.
//

import Foundation
import UIKit

protocol ListingEventHandlerProtocol {
    var viewController: ListingViewControllerProtocol? { get set }
    
    func fetchImage(with id: String, completion: @escaping (UIImage?) -> Void)
}
class ListingEventHandler: ListingEventHandlerProtocol {
    weak var viewController: ListingViewControllerProtocol?
    let interactor: ListingInteractorProtocol
    let router: ListingRouterProtocol
    
    init(interactor: ListingInteractorProtocol, router: ListingRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func fetchImage(with id: String, completion: @escaping (UIImage?) -> Void) {
        interactor.fetchImage(with: id, completion: completion)
    }
    
}

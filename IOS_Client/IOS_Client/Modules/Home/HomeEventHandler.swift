//
//  HomeEventHandler.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/14/23.
//

import Foundation

protocol HomeEventHandlerProtocol {
    
    var viewController: HomeViewControllerProtocol? { get set }
    
    func fetchPosts()
}

class HomeEventHandler: HomeEventHandlerProtocol {
    weak var viewController: HomeViewControllerProtocol?
    var interactor: HomeInteractorProtocol
    var router: HomeRouterProtocol
    
    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func fetchPosts() {
        interactor.fetchPosts { [weak self] posts in
            print("Posts received in HomeEventHandler: \(posts)") // add this
            DispatchQueue.main.async {
                self?.viewController?.updatePosts(posts)
            }
        }
    }
}


//
//  HomeEventHandler.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/14/23.
//

import Foundation
import UIKit

protocol HomeEventHandlerProtocol {
    
    var viewController: HomeViewControllerProtocol? { get set }
    
    func fetchPosts()
    func fetchImage(with id: String, completion: @escaping (UIImage?) -> Void)
    
    func didSelectPost(post: Post)
}

class HomeEventHandler: HomeEventHandlerProtocol {
    weak var viewController: HomeViewControllerProtocol?
    let interactor: HomeInteractorProtocol
    let router: HomeRouterProtocol
    
    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func fetchPosts() {
        interactor.fetchPosts { [weak self] posts in
            print("Posts received in HomeEventHandler: \(posts)")
            DispatchQueue.main.async {
                self?.viewController?.updatePosts(posts)
            }
        }
    }
    
    func fetchImage(with id: String, completion: @escaping (UIImage?) -> Void) {
        interactor.fetchImage(with: id, completion: completion)
    }
    
    func didSelectPost(post: Post) {
        router.navigateToPost(post: post)
    }
}


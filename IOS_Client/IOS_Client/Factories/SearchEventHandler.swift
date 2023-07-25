//
//  SearchEventHandler.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/25/23.
//

import Foundation
import UIKit

protocol SearchEventHandlerProtocol: AnyObject {
    var viewController: SearchViewControllerProtocol? { get set }
    
    func searchPosts(query: String)
    
    func fetchImage(with id: String, completion: @escaping (UIImage?) -> Void)
    
    func didSelectPost(post: Post)
}

class SearchEventHandler: SearchEventHandlerProtocol {
    weak var viewController: SearchViewControllerProtocol?
    let interactor: SearchInteractorProtocol
    let router: SearchRouterProtocol
    
    init(interactor: SearchInteractorProtocol, router: SearchRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func searchPosts(query: String) {
        interactor.searchPosts(query: query) { posts in
            DispatchQueue.main.async {
                self.viewController?.updateWithSearchResults(posts)
            }
        }
    }
    func fetchImage(with id: String, completion: @escaping (UIImage?)-> Void) {
        interactor.fetchImage(with: id, completion: completion)
    }
    
    func didSelectPost(post: Post) {
        router.navigateToPost(post: post)
    }
}

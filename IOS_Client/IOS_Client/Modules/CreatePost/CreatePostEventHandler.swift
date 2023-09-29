//
//  CreatePostEventHandler.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/28/23.
//

import Foundation
import UIKit

protocol CreatePostEventHandlerProtocol: AnyObject {
    var viewController: CreatePostViewControllerProtocol? { get set }
    
    func createPost(title: String, body: String, image: UIImage)
}

class CreatePostEventHandler: CreatePostEventHandlerProtocol {
    weak var viewController: CreatePostViewControllerProtocol?
    
    let interactor: CreatePostInteractorProtocol
    let router: CreatePostRouterProtocol
    
    init(interactor: CreatePostInteractorProtocol, router: CreatePostRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func createPost(title: String, body: String, image: UIImage) {
        interactor.createPost(title: title, body: body, image: image) { result in
            switch result {
            case .success(let message):
                print(message ?? "Post created!")
            case .failure(let error):
                print("Error creating post: \(error.localizedDescription)")
            }
        }
    }

    
}

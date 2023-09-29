//
//  CreatePostInteractor.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/28/23.
//

import Foundation
import UIKit

protocol CreatePostInteractorProtocol: AnyObject {
    func createPost(title: String, body: String, image: UIImage, completion: @escaping (Result<String?, Error>) -> Void)
}

class CreatePostInteractor: CreatePostInteractorProtocol {
    let dataManager: CreatePostDataManagerProtocol
    
    init(dataManager: CreatePostDataManagerProtocol = CreatePostDataManager()) {
        self.dataManager = dataManager
    }
    
    func createPost(title: String, body: String, image: UIImage, completion: @escaping (Result<String?, Error>) -> Void) {
        guard let username = TokenFactory.appToken.getUsername() else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get username"])
            completion(.failure(error))
            return
        }
        let post = Post(_id: nil, username: username, title: title, body: body, imageFileId: nil)
        
        dataManager.createPost(post: post, image: image, completion: completion)
    }
}

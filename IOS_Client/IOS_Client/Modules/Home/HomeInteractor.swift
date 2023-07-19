//
//  HomeInteractor.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/14/23.
//

import Foundation
import UIKit


protocol HomeInteractorProtocol {
    func fetchPosts(completion: @escaping ([Post]) -> Void)
    func fetchImage(with id: String, completion: @escaping (UIImage?) -> Void)
}

class HomeInteractor: HomeInteractorProtocol {
    let dataManager: HomeDataManager

    init(dataManager: HomeDataManager = HomeDataManager()) {
        self.dataManager = dataManager
    }

    func fetchPosts(completion: @escaping ([Post]) -> Void) {
        dataManager.fetchPosts { posts in
            print("Posts received in HomeInteractor: \(posts)")
            completion(posts)
        }
    }
    
    func fetchImage(with id: String, completion: @escaping (UIImage?)-> Void) {
        dataManager.fetchImage(with: id, completion: completion)
    }
}

//
//  SearchInteractor.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/25/23.
//

import Foundation
import UIKit

protocol SearchInteractorProtocol: AnyObject {
    
    func searchPosts(query: String, completion: @escaping ([Post]) -> Void)
    
    func fetchImage(with id: String, completion: @escaping (UIImage?) -> Void)
}

class SearchInteractor: SearchInteractorProtocol {
    let dataManager: SearchDataManagerProtocol

    init(dataManager: SearchDataManagerProtocol = SearchDataManager(imageFactory: ImageFactory())) {
        self.dataManager = dataManager
    }

    func searchPosts(query: String, completion: @escaping ([Post]) -> Void) {
        dataManager.searchPosts(query: query, completion: completion)
    }
    func fetchImage(with id: String, completion: @escaping (UIImage?)-> Void) {
        dataManager.fetchImage(with: id, completion: completion)
    }
}

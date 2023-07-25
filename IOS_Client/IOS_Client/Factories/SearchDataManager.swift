//
//  SearchDataManager.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/25/23.
//

import Foundation
import UIKit

protocol SearchDataManagerProtocol: AnyObject {
    
    func searchPosts(query: String, completion: @escaping ([Post]) -> Void)
    
    func fetchImage(with id: String, completion: @escaping (UIImage?) -> Void)
    
}

class SearchDataManager: SearchDataManagerProtocol {
    let imageFactory: ImageFactoryType

    init(imageFactory: ImageFactoryType) {
        self.imageFactory = imageFactory
    }

    func searchPosts(query: String, completion: @escaping ([Post]) -> Void) {
        guard let url = URL(string: MainConfig.serverAddress + "/search?query=" + query) else {
            print("failed to make url")
            completion([])
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion([])
            } else if let data = data {
                let decoder = JSONDecoder()

                if let posts = try? decoder.decode([Post].self, from: data) {
                    print("Posts decoded in SearchDataManager: \(posts)")
                    completion(posts)
                } else {
                    completion([])
                }
            }
        }

        task.resume()
    }
    
    func fetchImage(with id: String, completion: @escaping (UIImage?) -> Void) {
        imageFactory.fetchImage(with: id, completion: completion)
    }
}

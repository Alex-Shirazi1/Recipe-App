//
//  ImageFactory.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/21/23.
//

import Foundation
import UIKit

protocol ImageFactoryType {
    func fetchImage(with id: String, completion: @escaping (UIImage?) -> Void)
}

/// Handles all the Image fetching for the App
class ImageFactory: ImageFactoryType {
    func fetchImage(with id: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: MainConfig.serverAddress + "/image/" + id) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }
        
        task.resume()
    }
}

//
//  ListingDataManager.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/21/23.
//

import Foundation
import UIKit

protocol ListingDataManagerProtocol {
    func fetchImage(with id: String, completion: @escaping (UIImage?) -> Void)
}

class ListingDataManager: ListingDataManagerProtocol {
    let imageFactory: ImageFactoryType
    
    init(imageFactory: ImageFactoryType) {
        self.imageFactory = imageFactory
    }
    
    func fetchImage(with id: String, completion: @escaping (UIImage?) -> Void) {
        imageFactory.fetchImage(with: id, completion: completion)
    }
}

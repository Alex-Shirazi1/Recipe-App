//
//  ListingInteractor.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/21/23.
//

import Foundation
import UIKit

protocol ListingInteractorProtocol {
    func fetchImage(with id: String, completion: @escaping (UIImage?) -> Void)
}
class ListingInteractor: ListingInteractorProtocol {
    let dataManager: ListingDataManagerProtocol
    
    init(dataManager: ListingDataManager = ListingDataManager(imageFactory: ImageFactory())) {
        self.dataManager = dataManager
    }
    func fetchImage(with id: String, completion: @escaping (UIImage?) -> Void) {
        dataManager.fetchImage(with: id, completion: completion)
    }
}

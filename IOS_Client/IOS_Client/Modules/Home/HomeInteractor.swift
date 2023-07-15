//
//  HomeInteractor.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/14/23.
//

protocol HomeInteractorProtocol {
    func fetchPosts(completion: @escaping ([Post]) -> Void)
}

class HomeInteractor: HomeInteractorProtocol {
    let dataManager: HomeDataManager

    init(dataManager: HomeDataManager = HomeDataManager()) {
        self.dataManager = dataManager
    }

    func fetchPosts(completion: @escaping ([Post]) -> Void) {
        dataManager.fetchPosts { posts in
            print("Posts received in HomeInteractor: \(posts)") // add this
            completion(posts)
        }
    }

}

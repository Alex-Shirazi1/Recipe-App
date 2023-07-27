//
//  FeedbackData.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/27/23.
//

import Foundation

class FeedbackData: Codable {
    let recommend: Bool
    let comments: String
    
    init(recommend: Bool, comments: String) {
        self.recommend = recommend
        self.comments = comments
    }
}

//
//  Post.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/14/23.
//

import Foundation
import UIKit

struct Post: Codable {
    let _id: String?
    let username: String
    let title: String
    let body: String
    let imageFileId: String?
    
    private enum CodingKeys: String, CodingKey {
        case _id, username, title, body, imageFileId
    }
}

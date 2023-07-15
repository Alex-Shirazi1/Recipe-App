//
//  Post.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/14/23.
//

import Foundation


struct Post: Codable {
    let _id: String  // For Mongo automated Unique IDS
    let title: String
    let body: String
}


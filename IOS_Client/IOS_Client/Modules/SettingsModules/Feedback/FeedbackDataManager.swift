//
//  FeedbackDataManager.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/26/23.
//

import Foundation

protocol FeedbackDataManagerProtocol: AnyObject {
    func sendFeedback(data: FeedbackData)
}

class FeedbackDataManager: FeedbackDataManagerProtocol {

    func sendFeedback(data: FeedbackData) {
        guard let url = URL(string: "\(MainConfig.serverAddress)/sendFeedback") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(data)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response: \(httpResponse.statusCode)")
            }
        }.resume()
    }
}

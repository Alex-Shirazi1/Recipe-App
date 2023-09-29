//
//  CreatePostDataManager.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/28/23.
//

import Foundation
import UIKit

protocol CreatePostDataManagerProtocol: AnyObject {
    func createPost(post: Post, image: UIImage, completion: @escaping (Result<String?, Error>) -> Void)
}

class CreatePostDataManager: CreatePostDataManagerProtocol {
    
    func createPost(post: Post, image: UIImage, completion: @escaping (Result<String?, Error>) -> Void) {
        
        guard let url = URL(string: MainConfig.serverAddress + "/createPost") else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create URL"])
            completion(.failure(error))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            let error = NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image"])
            completion(.failure(error))
            return
        }

        let boundary = UUID().uuidString
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var httpBody = Data()

        let parameters: [String: String] = [
            "title": post.title,
            "body": post.body,
            "username": post.username
        ]
        
        for (key, value) in parameters {
            httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
            httpBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            httpBody.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        httpBody.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        httpBody.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        httpBody.append(imageData)
        httpBody.append("\r\n".data(using: .utf8)!)
        httpBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                let error = NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])
                completion(.failure(error))
                return
            }

            // Print raw server response for debugging
            print("Raw server response: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
            
            do {
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let message = dictionary?["message"] as? String
                completion(.success(message))
            } catch {
                print("Error while decoding JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

//
//  LoginDataManager.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation


protocol LoginDataManagerProtocol: AnyObject {
    func proceedLogin(login: Login, completion: @escaping (Bool) -> Void)
}

class LoginDataManager: LoginDataManagerProtocol {
    
    func proceedLogin(login: Login, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: MainConfig.serverAddress + "/login") else {
            print("failed to make url")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(login)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode login: \(error)")
            completion(false)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  error == nil else {
                print("Login request failed: \(error?.localizedDescription ?? "No data")")
                completion(false)
                return
            }
            completion(true)
        }

        task.resume()
    }

}

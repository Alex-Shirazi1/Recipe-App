//
//  LoginDataManager.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation


protocol LoginDataManagerProtocol: AnyObject {
    func proceedLogin(login: Login, completion: @escaping (String?, String?, Error?) -> Void)
}

class LoginDataManager: LoginDataManagerProtocol {
    
    /// If sucessful, this function with produce a token to be used with our login session
    func proceedLogin(login: Login, completion: @escaping (String?, String?, Error?) -> Void) {
        guard let url = URL(string: MainConfig.serverAddress + "/login") else {
            print("failed to make url")
            completion(nil, nil, nil)
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
            completion(nil, nil, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  error == nil, let data = data else {
                      print("Login request failed: \(error?.localizedDescription ?? "No data")")
                      completion(nil, nil, error)
                      return
                  }
            
            do {
                guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to parse server response"])
                    completion(nil, nil, error)
                    return
                }
                
                if dictionary["loggedIn"] as? Bool == true {
                    let token = dictionary["token"] as? String
                    let username = dictionary["username"] as? String
                    completion(token, username, nil)
                } else {
                    // If login failed, there should be an errorMessage
                    let errorMessage = dictionary["errorMessage"] as? String ?? "Unknown error"
                    let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(nil, nil, error)
                }
                
            } catch {
                print("Failed to decode JSON: \(error)")
                completion(nil, nil, error)
            }
        }
        task.resume()
    }

}

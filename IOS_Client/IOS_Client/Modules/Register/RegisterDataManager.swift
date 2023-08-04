//
//  RegisterDataManager.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation


protocol RegisterDataManagerProtocol: AnyObject {
    func proceedRegister(registerDetails: Register, completion: @escaping (Result<String?, Error>) -> Void)
}

class RegisterDataManager: RegisterDataManagerProtocol {

    
    func proceedRegister(registerDetails: Register, completion: @escaping (Result<String?, Error>) -> Void) {
        
        
        guard let url = URL(string: MainConfig.serverAddress + "/register") else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create URL"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(registerDetails)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode registerDetails: \(error)")
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  error == nil, let data = data else {
                if let error {
                    completion(.failure(error))
                }
                return
            }
            
            do {
                guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to parse server response"])
                    completion(.failure(error))
                    return
                }
                
                let message = dictionary["message"] as? String
                completion(.success(message))
                
            } catch {
                print("Failed to decode JSON: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

}

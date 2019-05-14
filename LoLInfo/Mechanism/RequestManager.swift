//
//  RequestManager.swift
//  LoLInfo
//
//  Created by Scarpz on 21/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation

class RequestManager {
    
    /// Method responsible to perform a HTTP request based on given information
    ///
    /// - Parameters:
    ///   - url: URL to try to access
    ///   - method: Method of the request
    ///   - headers: Headers of the request, if existing
    ///   - body: Body of the request, if existing
    ///   - completion: Dictionary of the response received from the request
    static func request(url: URL, method: RequestMethod, headers: [String : String]?, body: Data?, success: @escaping (_ success: Data) -> Void, requestError: @escaping (_ error: Error) -> Void) {
        
        // Creates a Requesr
        var request = URLRequest(url: url)
        
        // Fills the request information
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        
        print(request)
        
        // Performs the task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                print("✅✅✅✅✅\n\n\(response)\n\n✅✅✅✅✅")
                success(data)
            }
            if let error = error {
                print("❌❌❌❌❌\n\n\(error)\n\n❌❌❌❌❌")
                requestError(error)
            }
        }
        task.resume()
    }
    
}

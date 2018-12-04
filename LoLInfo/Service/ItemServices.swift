//
//  ItemServices.swift
//  LoLInfo
//
//  Created by Scarpz on 23/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation

class ItemServices {
    
    /// Method responsible to get all Items
    ///
    /// - Parameter completion: Returns the list of Items, if existing
    static func getAllItems(completion: @escaping ([Item]?) -> Void) {
        
        // Garantee the URL
        guard let url = URL(string: BaseURL.itemList) else {
            completion(nil)
            return
        }
        
        // Perform the request
        RequestManager.request(url: url, method: .get, headers: nil, body: nil) { response, error in
            if let _ = error {
                completion(nil)
                
            } else if let validResponse = response {
                
                // Check the data of the response
                if let itemsJson = validResponse["data"] as? [String : Any] {
                    
                    // Returns the parsed Item list from the dictionary
                    completion(ResponseParser.parseItemList(from: itemsJson))
                    
                } else {
                    completion(nil)
                }
            }
        }
    }
}

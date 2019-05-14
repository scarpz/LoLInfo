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
    static func getAllItems(itens: @escaping ([Item]) -> Void, failure: @escaping (Error) -> Void) {
        
        PatchServices.getPatch(patch: { latestPatch in
            
            // Guarantees the URL
            guard let url = URL(string: BaseURL.itemList.replacingOccurrences(of: "{{patch}}", with: latestPatch)) else {
                failure(Errors.urlParseError)
                return
            }
            
            // Performs the request
            RequestManager.request(url: url, method: .get, headers: nil, body: nil, success: { response in
                
                do {
                    // Gets a Dictionary value of the data received from the server
                    let json = try JSONSerialization.jsonObject(with: response, options: []) as! [String : Any]
                    
                    // Checks the data of the response
                    if let itemsJson = json["data"] as? [String : Any] {
                        // Returns the parsed Item list from the dictionary
                        itens(ResponseParser.parseItemList(from: itemsJson))
                    } else {
                        failure(Errors.dictionaryParseError)
                    }
                } catch let error {
                    failure(error)
                }
            }) { error in
                failure(error)
            }
        }) { error in
            failure(error)
        }
    }
}

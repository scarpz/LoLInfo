//
//  PatchServices.swift
//  LoLInfo
//
//  Created by Scarpz on 21/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation

/// Struct responsible to store the current Patch of the game
class PatchServices {
    
    static func getPatch(patch: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        
        if let latestPatch = self.getPatchFromUserDefaults() {
            patch(latestPatch)
        } else {
            self.getPatchFromServer(patch: { latestPatch in
                self.savePatchInUserDefaults(patch: latestPatch)
                patch(latestPatch)
            }) { error in
                failure(error)
            }
        }
    }
    
    static func getPatchFromServer(patch: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        
        // Guarantees the URL
        guard let url = URL(string: BaseURL.patchList) else {
            failure(Errors.urlParseError)
            return
        }
        
        RequestManager.request(url: url, method: .get, headers: nil, body: nil, success: { response in
            
            do {
                // Gets a Dictionary value of the data received from the server
                let patches = try JSONSerialization.jsonObject(with: response, options: []) as! [String]
                
                if !patches.isEmpty {
                    patch(patches.first!)
                } else {
                    failure(Errors.noValues)
                }
            } catch let error {
                failure(error)
            }
        }) { error in
            failure(error)
        }
        
    }
    
    
    private static let userDefaultsPatchKey = "latestPatch"
    
    private static func savePatchInUserDefaults(patch: String) {
        UserDefaults.standard.set(patch, forKey: self.userDefaultsPatchKey)
        UserDefaults.standard.synchronize()
    }
    
    static func getPatchFromUserDefaults() -> String? {
        return UserDefaults.standard.string(forKey: self.userDefaultsPatchKey)
    }
}

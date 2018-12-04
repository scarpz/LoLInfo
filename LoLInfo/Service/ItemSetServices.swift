//
//  ItemSetServices.swift
//  LoLInfo
//
//  Created by Scarpz on 01/12/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation

class ItemSetServices {
    
    /// Method responsible to get all Item Set
    ///
    /// - Parameter completion: Returns the list of Item Set, if existing
    static func getAllItemSets(completion: @escaping ([ItemSet]?) -> Void) {
        
        completion([ItemSet]())
    }
    
    /// Method responsible to save the new Item Set in the application
    ///
    /// - Parameter itemSet: Item Set to be saved
    static func saveItemSet(itemSet: ItemSet) {
        
    }
    
    /// Method responsible to remove the Item Set in the application
    ///
    /// - Parameter itemSet: Item Set to be removed
    static func removeItemSet(itemSet: ItemSet) {
        
    }
}

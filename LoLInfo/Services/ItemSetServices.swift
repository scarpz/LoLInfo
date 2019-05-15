//
//  ItemSetServices.swift
//  LoLInfo
//
//  Created by Scarpz on 01/12/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation
import CoreData

class ItemSetServices {
    
    /// Method responsible to get all Item Set
    ///
    /// - Returns: Returns the list of Item Set, if existing
    /// - Throws: Throw an error if something goes wrong
    static func getAllItemSets() throws -> [ItemSetCoreData] {
        
        // List of ItemSets to be returned
        var itemSetCoreData: [ItemSetCoreData]
        
        do {
            // Creating fetch request
            let request: NSFetchRequest = NSFetchRequest<ItemSetCoreData>()
            request.entity = NSEntityDescription.entity(forEntityName: "ItemSetCoreData", in: CoreDataManager.shared.persistentContainer.viewContext)
            
            // Performs search
            itemSetCoreData = try CoreDataManager.shared.persistentContainer.viewContext.fetch(request)
        }
        catch {
            throw Errors.coreDataFailure
        }
        
        return itemSetCoreData
    }
    
    /// Method responsible to save the new Item Set in the application
    ///
    /// - Parameter itemSet: Item Set to be saved
    /// - Throws: Throw an error if something goes wrong
    static func saveItemSet(itemSet: ItemSet) throws {
        
        // Creates a Core Data object based on the ItemSet model
        let itemSetCoreData = ItemSetCoreData()
        itemSetCoreData.name = itemSet.name
        itemSetCoreData.date = itemSet.date
        itemSetCoreData.championId = itemSet.champion.stringId
        for item in itemSet.items {
            itemSetCoreData.itemsId.append("\(item.id)")
        }
        
        do {
            // Adds object to be saved to the context
            CoreDataManager.shared.persistentContainer.viewContext.insert(itemSetCoreData)
            
            // Persists changes at the context
            try CoreDataManager.shared.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.coreDataFailure
        }
    }

    /// Method responsible to remove the Item Set in the application
    ///
    /// - Parameter itemSet: Item Set to be removed
    /// - Throws: Throw an error if something goes wrong
    static func removeItemSet(itemSet: ItemSetCoreData) throws {
        
        do {
            // Deletes element from context
            CoreDataManager.shared.persistentContainer.viewContext.delete(itemSet)
            
            // Persists the operation
            try CoreDataManager.shared.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.coreDataFailure
        }
    }
}

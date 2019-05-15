//
//  ItemSetCoreData.swift
//  LoLInfo
//
//  Created by Scarpz on 05/12/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation
import CoreData

class ItemSetCoreData: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var date: Date
    @NSManaged var championId: String
    @NSManaged var itemsId: [String]
    
    convenience init() {
        // Get context
        let managedObjectContext: NSManagedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
        
        // Create entity description
        let entityDescription = NSEntityDescription.entity(forEntityName: "ItemSetCoreData", in: managedObjectContext)
        
        // Call super
        self.init(entity: entityDescription!, insertInto: nil)
    }
}

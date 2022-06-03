//
//  StockTickerEntity.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
import CoreData
 
struct StockTickerDBEntity {
    let id: Int
    let name: String
    let values: [StockValue]

    func reduce(values: [StockValue]?) -> StockTickerDBEntity {
        return StockTickerDBEntity(
            id: id,
            name: name,
            values: values ?? self.values
        )
    }
    
    func newValueAdded(newValue: StockValue) -> StockTickerDBEntity {
        var newValues = values
        newValues.append(newValue)
        return StockTickerDBEntity(
            id: id,
            name: name,
            values: newValues
        )
    }
}

//Core Data
extension StockTickerDBEntity {
    func createInsertRequest(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: "StockTickerEntity",
            in: context
        )!
        let managedObject = NSManagedObject(
            entity: entity,
            insertInto: context
        )
        
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(name, forKey: "name")
    }
    
    static func createFetchRequest(context: NSManagedObjectContext) -> NSFetchRequest<NSManagedObject> {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "StockTickerEntity")
        
        return fetchRequest
    }
    
    static func create(using object: NSManagedObject) -> StockTickerDBEntity {
        return StockTickerDBEntity(
            id: object.value(forKey: "id") as! Int,
            name: object.value(forKey: "name") as! String,
            values: []
        )
    }
}

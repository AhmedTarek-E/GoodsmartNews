//
//  StockValue.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
import CoreData

struct StockValue {
    let id: Int
    let value: Double
    let stockTickerId: Int
}
//Core Data
extension StockValue {
    func createInsertRequest(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: "StockValueEntity",
            in: context
        )!
        let managedObject = NSManagedObject(
            entity: entity,
            insertInto: context
        )
        
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(value, forKey: "value")
        managedObject.setValue(stockTickerId, forKey: "stockTickerId")
    }
    
    static func createFetchRequest(context: NSManagedObjectContext) -> NSFetchRequest<NSManagedObject> {
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "StockValueEntity")
        return fetchRequest
    }
    
    static func create(using object: NSManagedObject) -> StockValue {
        return StockValue(
            id: object.value(forKey: "id") as! Int,
            value: object.value(forKey: "value") as! Double,
            stockTickerId: object.value(forKey: "stockTickerId") as! Int
        )
    }
}

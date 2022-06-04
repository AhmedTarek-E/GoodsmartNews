//
//  ArticleItem+CoreData.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
import CoreData

//Core Data
extension ApiArticleItem {
    func createInsertRequest(
        context: NSManagedObjectContext
    ) {
        let entity = NSEntityDescription.entity(
            forEntityName: "ArticleEntity",
            in: context
        )!
        let managedObject = NSManagedObject(
            entity: entity,
            insertInto: context
        )
        
        let id = Int.random(in: 0...1000)
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(content, forKey: "content")
        managedObject.setValue(author, forKey: "author")
        managedObject.setValue(articleDescription, forKey: "desc")
        managedObject.setValue(publishedAt, forKey: "publishedAt")
        managedObject.setValue(title, forKey: "title")
        managedObject.setValue(url, forKey: "url")
        managedObject.setValue(urlToImage, forKey: "urlToImage")
    }
    
    static func createFetchRequest(context: NSManagedObjectContext) -> NSFetchRequest<NSManagedObject> {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "ArticleEntity")
        
        return fetchRequest
    }
    
    static func create(using object: NSManagedObject) -> ApiArticleItem {
        return ApiArticleItem(
            author: object.value(forKey: "author") as? String,
            title: object.value(forKey: "title") as? String,
            articleDescription: object.value(forKey: "desc") as? String,
            url: object.value(forKey: "url") as? String,
            urlToImage: object.value(forKey: "urlToImage") as? String,
            publishedAt: object.value(forKey: "publishedAt") as? String ,
            content: object.value(forKey: "content") as? String
        )
    }
}

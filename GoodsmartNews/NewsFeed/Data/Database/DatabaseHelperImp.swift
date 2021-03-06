//
//  DatabaseHelperImp.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
import RxSwift
import CoreData

class DatabaseHelperImp: DatabaseHelper {
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
     
    private let persistentContainer: NSPersistentContainer
    
    private lazy var context: NSManagedObjectContext = {
        let privateMoc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMoc.parent = persistentContainer.viewContext
        return privateMoc
    }()
    
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func insertStockTicker(ticker: StockTickerDBEntity) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer in
            self?.context.performAndWait { [weak self] in
                guard let self = self else { return }
                
                defer {
                    observer.onCompleted()
                }
                
                ticker.createInsertRequest(context: self.context)
                
                do {
                    try self.context.save()
                    
                    self.mainContext.performAndWait {
                        do {
                            try self.mainContext.save()
                            observer.onNext(())
                        } catch let error {
                            observer.onError(error)
                        }
                    }
                    
                } catch let error {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    
    func getStockTickers() -> Observable<[StockTickerDBEntity]> {
        return Observable<[StockTickerDBEntity]>.create { [weak self] observer in
            
            self?.context.performAndWait { [weak self] in
                guard let self = self else { return }
                
                defer {
                    observer.onCompleted()
                }
                
                let request = StockTickerDBEntity
                    .createFetchRequest(context: self.context)
                
                do {
                    let objects = try self.context.fetch(request)
                    
                    let tickers = objects.map { object in
                        return StockTickerDBEntity.create(using: object)
                    }
                    observer.onNext(tickers)
                } catch let error {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func insertStockValues(value: StockValue) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer in
            self?.context.performAndWait { [weak self] in
                guard let self = self else { return }
                value.createInsertRequest(context: self.context)
                
                defer {
                    observer.onCompleted()
                }
                
                do {
                    try self.context.save()
                    self.mainContext.performAndWait {
                        do {
                            try self.mainContext.save()
                            observer.onNext(())
                        } catch let error {
                            observer.onError(error)
                        }
                    }
                } catch let error {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getStockValues() -> Observable<[StockValue]> {
        return Observable<[StockValue]>.create { [weak self] observer in
            
            self?.context.performAndWait { [weak self] in
                guard let self = self else { return }
                
                defer {
                    observer.onCompleted()
                }
                
                let request = StockValue
                    .createFetchRequest(context: self.context)
                
                do {
                    let objects = try self.context.fetch(request)
                    
                    let values = objects.map { object in
                        return StockValue.create(using: object)
                    }
                    observer.onNext(values)
                } catch let error {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func insertArticle(article: ApiArticleItem) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer in
            self?.context.performAndWait { [weak self] in
                guard let self = self else { return }
                
                defer {
                    observer.onCompleted()
                }
                
                article.createInsertRequest(context: self.context)
                
                do {
                    try self.context.save()
                    self.mainContext.performAndWait {
                        do {
                            try self.mainContext.save()
                            observer.onNext(())
                        } catch let error {
                            observer.onError(error)
                        }
                    }
                } catch let error {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }

    }
    
    func getArticles() -> Observable<[ApiArticleItem]> {
        return Observable<[ApiArticleItem]>.create { [weak self] observer in
            
            self?.context.performAndWait { [weak self] in
                guard let self = self else { return }
                
                defer {
                    observer.onCompleted()
                }
                
                let request = ApiArticleItem
                    .createFetchRequest(context: self.context)
                
                do {
                    let objects = try self.context.fetch(request)
                    
                    let articles = objects.map { object in
                        return ApiArticleItem.create(using: object)
                    }
                    observer.onNext(articles)
                    
                } catch let error {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}

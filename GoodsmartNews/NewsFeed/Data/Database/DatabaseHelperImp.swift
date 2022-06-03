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
    
    private var context: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func insertStockTicker(ticker: StockTickerDBEntity) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer in
            self?.context.performAndWait { [weak self] in
                guard let self = self else { return }
                ticker.createInsertRequest(context: self.context)
                
                do {
                    try self.context.save()
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
                
                do {
                    try self.context.save()
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
}

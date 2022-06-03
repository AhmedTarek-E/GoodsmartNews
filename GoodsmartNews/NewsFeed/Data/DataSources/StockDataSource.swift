//
//  StockDataSource.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
import RxSwift
import Alamofire

class StockDataSource {
    static private let stockEndpoint = "https://raw.githubusercontent.com/dsancov/TestData/main/stocks.csv"
    
    init(database: DatabaseHelper) {
        self.database = database
    }
    
    let database: DatabaseHelper
    
    func getStockTickers() -> Observable<[StockTickerDBEntity]> {
        return getStockTickerWithValues()
            .withUnretained(self)
            .flatMap { (source, tickers) -> Observable<[StockTickerDBEntity]> in
                
                if tickers.isEmpty {
                    return source.fetchAndSave()
                } else {
                    return Observable.just(tickers)
                }
            }
    }
    
    private func getStockTickerWithValues() -> Observable<[StockTickerDBEntity]> {
        return Observable.combineLatest(
            database.getStockTickers(),
            database.getStockValues()
        ).map { (tickers, values) in
            var items = [StockTickerDBEntity]()
            for ticker in tickers {
                let values = values.filter { value in
                    value.stockTickerId == ticker.id
                }
                items.append(
                    ticker.reduce(values: values)
                )
            }
            
            return items
        }
    }
    
    private func fetchAndSave() -> Observable<[StockTickerDBEntity]> {
        return fetchFromApi().flatMap { [weak self] rows -> Observable<[StockTickerDBEntity]> in
            guard let self = self else { return Observable.error(UnexpectedError("")) }
                                                                 
            return self.saveToDatabase(rows: rows)
                .flatMap { [weak self] _ -> Observable<[StockTickerDBEntity]> in
                    guard let self = self else { return Observable.error(UnexpectedError("")) }
                    
                return self.getStockTickerWithValues()
            }
            
        }
    }
    
    private func saveToDatabase(rows: [StockRow]) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer in
            var disposable: Disposable?
            
            if let self = self {
                let tickers = self.prepareEntities(rows: rows)
                
                let observables = tickers.map { entity -> [Observable<Void>] in
                    var insertions = [self.database.insertStockTicker(ticker: entity)]
                    insertions.append(
                        contentsOf: entity.values.map({ stockValue in
                            return self.database.insertStockValues(value: stockValue)
                        })
                    )
                    return insertions
                }.flatMap { innerArray in
                    return innerArray
                }
                
                disposable = Observable.concat(observables)
                    .subscribe(
                        on: ConcurrentDispatchQueueScheduler.init(
                            queue: DispatchQueue.global()
                        )
                    )
                    .subscribe(
                        onNext: { _ in
                            observer.onNext(())
                            observer.onCompleted()
                        },
                        onError: { error in
                            observer.onError(error)
                            observer.onCompleted()
                        }
                    )
            }
            
            return Disposables.create {
                disposable?.dispose()
            }
        }
    }
    
    private func prepareEntities(rows: [StockRow]) -> [StockTickerDBEntity] {
        var tickers = [StockTickerDBEntity]()
        
        for (rowIndex, row) in rows.enumerated() {
            if let index = tickers.firstIndex(where: { entity in
                row.stock == entity.name
            }) {
                let ticker = tickers[index]
                let newValue = StockValue(
                    id: rowIndex,
                    value: row.price,
                    stockTickerId: ticker.id
                )
                tickers[index] = ticker.newValueAdded(newValue: newValue)
            } else {
                let ticker = StockTickerDBEntity(
                    id: tickers.count,
                    name: row.stock,
                    values: [
                        StockValue(
                            id: rowIndex,
                            value: row.price,
                            stockTickerId: tickers.count
                        )
                    ]
                )
                tickers.append(ticker)
            }
        }
        
        return tickers
    }
    
    private func fetchFromApi() -> Observable<[StockRow]> {
        return Observable.create { observer in
            if let url = URL(string: StockDataSource.stockEndpoint) {
                AF.request(url,method: .get).response { [weak self] response in
                    if let error = response.error {
                        observer.onError(error)
                    } else if let data = response.data,
                        let content = String(data: data, encoding: .utf8) {
                        
                        observer.onNext(
                            self?.parseCSVContent(content: content) ?? []
                        )
                    } else {
                        observer.onError(UnexpectedError("can't parse stock endpoint"))
                    }
                }
            } else {
                observer.onError(UnexpectedError("can't parse stock endpoint"))
            }
            
            return Disposables.create()
        }
    }
    
    private func parseCSVContent(content: String) -> [StockRow] {
        let rows = content.split(separator: "\n").dropFirst()
        return rows.compactMap { subString in
            let columns = subString.split(separator: ",")
            if columns.count == 2 {
                let price = String(columns[1]).trimmingCharacters(in: [" "])
                
                return StockRow(
                    stock: String(columns[0]),
                    price: Double(price) ?? 0
                )
            }
            
            return nil
        }
    }
}

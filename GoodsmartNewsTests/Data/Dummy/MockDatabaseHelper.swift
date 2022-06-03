//
//  MockDatabaseHelper.swift
//  GoodsmartNewsTests
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
@testable import GoodsmartNews
import RxSwift

class MockDatabaseHelper: DatabaseHelper {
    func insertStockTicker(ticker: StockTickerDBEntity) -> Observable<Void> {
        return Observable.just(())
    }
    
    func getStockTickers() -> Observable<[StockTickerDBEntity]> {
        return Observable.just([])
    }
    
    func insertStockValues(value: StockValue) -> Observable<Void> {
        return Observable.just(())
    }
    
    func getStockValues() -> Observable<[StockValue]> {
        return Observable.just([])
    }
    
    
}

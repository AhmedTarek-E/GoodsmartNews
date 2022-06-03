//
//  MockStockDataSource.swift
//  GoodsmartNewsTests
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
@testable import GoodsmartNews
import RxSwift

class MockStockDataSource: StockDataSource {
    init() {
        super.init(database: MockDatabaseHelper())
    }
    
    override func getStockTickers() -> Observable<[StockTickerDBEntity]> {
        return Observable.just([
            StockTickerDBEntity(
                id: 0,
                name: "Tesla",
                values: [
                    StockValue(
                        id: 0,
                        value: 190,
                        stockTickerId: 0
                    ),
                    StockValue(
                        id: 1,
                        value: 160,
                        stockTickerId: 0
                    ),
                    StockValue(
                        id: 2,
                        value: 173,
                        stockTickerId: 0
                    )
                ]
            ),
            StockTickerDBEntity(
                id: 1,
                name: "Microsoft",
                values: [
                    StockValue(
                        id: 3,
                        value: 123,
                        stockTickerId: 1
                    ),
                    StockValue(
                        id: 4,
                        value: 90,
                        stockTickerId: 1
                    ),
                    StockValue(
                        id: 5,
                        value: 140,
                        stockTickerId: 1
                    )
                ]
            )
        ])
    }
}

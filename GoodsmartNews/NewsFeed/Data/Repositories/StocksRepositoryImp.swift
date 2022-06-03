//
//  StocksRepositoryImp.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
import RxSwift

class StocksRepositoryImp: StocksRepository {
    init(dataSource: StockDataSource) {
        self.dataSource = dataSource
    }
    
    private let dataSource: StockDataSource
    
    private var latestRandomNumber: Int = 0
    private var latestGenerationDate = Date.now
    
    func getStockTickers() -> Observable<[StockTicker]> {
        let timePassed = Date.now.timeIntervalSince1970 - latestGenerationDate.timeIntervalSince1970
        if timePassed >= 1 {
            latestRandomNumber = Int.random(in: 0...100)
            latestGenerationDate = Date.now
        }
        
        return dataSource.getStockTickers()
            .withUnretained(self)
            .map { (repository, entities) in
                return entities.map { entity in
                    let valueIndex = repository.latestRandomNumber / entity.values.count
                    return StockTicker(
                        name: entity.name,
                        value: entity.values[valueIndex].value
                    )
                }
            }
    }
}

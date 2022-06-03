//
//  MockStocksRepository.swift
//  GoodsmartNewsTests
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
@testable import GoodsmartNews

import RxSwift
import UIKit

class MockStocksRepository: StocksRepository {
    var shouldThrow = false
    
    func getStockTickers() -> Observable<[StockTicker]> {
        if shouldThrow {
            return Observable.error(NSError())
        }
        return Observable.just([
            StockTicker(name: "Tesla", value: 190.0),
            StockTicker(name: "V", value: 5.9),
            StockTicker(name: "Com", value: -34.8)
        ])
    }
    
}

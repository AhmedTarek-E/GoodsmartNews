//
//  DatabaseHelper.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
import RxSwift

protocol DatabaseHelper {
    func insertStockTicker(ticker: StockTickerDBEntity) -> Observable<Void>
    func getStockTickers() -> Observable<[StockTickerDBEntity]>
    
    func insertStockValues(value: StockValue) -> Observable<Void>
    func getStockValues() -> Observable<[StockValue]>
}

//
//  StocksRepositoryImp.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
import RxSwift

class StocksRepositoryImp: StocksRepository {
    func getStockTickers() -> Observable<[StockTicker]> {
        //TODO: get stocks
        return Observable.just([])
    }
}

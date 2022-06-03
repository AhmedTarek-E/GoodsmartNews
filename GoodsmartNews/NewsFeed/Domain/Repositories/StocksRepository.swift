//
//  StocksRepository.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
import RxSwift

protocol StocksRepository {
    func getStockTickers() -> Observable<[StockTicker]>
}

//
//  GetStockTickersUseCase.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
import RxSwift

protocol GetStockTickersUseCase {
    func execute() -> Observable<[StockTicker]>
}

class GetStockTickersUseCaseImp: GetStockTickersUseCase {
    init(repository: StocksRepository) {
        self.repository = repository
    }
    
    let repository: StocksRepository
    
    func execute() -> Observable<[StockTicker]> {
        return repository.getStockTickers()
    }
}


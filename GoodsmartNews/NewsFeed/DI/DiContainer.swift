//
//  DiContainer.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 04/06/2022.
//

import Foundation
import UIKit

class DiContainer {
    private init() {}
    
    private static var databaseHelper: DatabaseHelper?
    
    static func getNewsFeedViewModel() -> NewsFeedViewModel {
        return NewsFeedViewModel(
            getStockTickersUseCase: GetStockTickersUseCaseImp(
                repository: StocksRepositoryImp(
                    dataSource: StockDataSource(
                        database: getDatabaseHelper()
                    )
                )
            ),
            getNewsUseCase: GetNewsUseCaseImp(
                repository: NewsRepositoryImp(
                    dataSource: NewsDataSource(
                        database: getDatabaseHelper()
                    )
                )
            )
        )
    }
    
    static func getDatabaseHelper() -> DatabaseHelper {
        if (databaseHelper == nil) {
            databaseHelper = DatabaseHelperImp(
                persistentContainer: AppDelegate.shared.persistentContainer
            )
        }
        
        return databaseHelper!
    }
    
}

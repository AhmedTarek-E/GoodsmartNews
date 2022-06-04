//
//  NewsFeedState.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 04/06/2022.
//

import Foundation

struct NewsFeedState {
    
    static func initial() -> NewsFeedState {
        return NewsFeedState(
            stockTickers: .initial,
            news: .initial
        )
    }
    
    init(stockTickers: Asyncronous<[StockTicker]>, news: Asyncronous<[Article]>) {
        self.stockTickers = stockTickers
        self.news = news
    }
    
    let stockTickers: Asyncronous<[StockTicker]>
    let news: Asyncronous<[Article]>
    
    var latestNews: [Article] {
        switch news {
        case .success(let data):
            return Array(data.prefix(6))
        default:
            return []
        }
    }
    
    var verticalNews: [Article] {
        switch news {
        case .success(let data):
            return Array(data.dropFirst(6))
        default:
            return []
        }
    }
    
    func reduce(
        stockTickers: Asyncronous<[StockTicker]>?,
        news: Asyncronous<[Article]>?
    ) -> NewsFeedState {
        return NewsFeedState(
            stockTickers: stockTickers ?? self.stockTickers,
            news: news ?? self.news
        )
    }
}

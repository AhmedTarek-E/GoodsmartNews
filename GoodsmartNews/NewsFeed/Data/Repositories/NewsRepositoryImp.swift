//
//  NewsRepositoryImp.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
import RxSwift

class NewsRepositoryImp: NewsRepository {
    init(dataSource: NewsDataSource) {
        self.dataSource = dataSource
    }
    
    private let dataSource: NewsDataSource
    
    func getNewsArticles() -> Observable<[Article]> {
        return dataSource.getNews().map { articles in
            return articles.map { item in
                item.map()
            }
        }
    }
    
}

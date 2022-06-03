//
//  NewsRepositoryImp.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
import RxSwift

class NewsRepositoryImp: NewsRepository {
    
    func getNewsArticles() -> Observable<[Article]> {
        //TODO: use data source
        return Observable.just([])
    }
    
}

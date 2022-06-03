//
//  MockNewsRepository.swift
//  GoodsmartNewsTests
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
@testable import GoodsmartNews
import RxSwift

class MockNewsRepository: NewsRepository {
    var shouldThrow = false
    
    func getNewsArticles() -> Observable<[Article]> {
        if shouldThrow {
            return Observable.error(NSError())
        }
        return Observable.just([
            Article(
                title: "New New New",
                description: "Somwthing big happened",
                image: "https://www.ccc.com/sasdasd.jpg",
                url: "https://www.ccc.com/news/adfsdfsdf",
                publishedAt: Date.now
            ),
        ])
    }
}

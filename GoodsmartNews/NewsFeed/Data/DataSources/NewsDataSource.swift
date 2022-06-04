//
//  NewsDataSource.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
import RxSwift
import Alamofire

class NewsDataSource {
    static private let newsEndpoint = "https://saurav.tech/NewsAPI/everything/cnn.json"
    
    init(database: DatabaseHelper) {
        self.database = database
    }
    
    private let database: DatabaseHelper
    
    func getNews() -> Observable<[ApiArticleItem]> {
        Observable<[ApiArticleItem]>.create { [weak self] observer in
            var disposables = [Disposable]()
            
            if let self = self {
                
                var savedArticles = [ApiArticleItem]()
                
                disposables.append(
                    self.database.getArticles()
                        .subscribe(
                            on: ConcurrentDispatchQueueScheduler.init(
                                queue: DispatchQueue.global()
                            )
                        )
                        .subscribe(
                            onNext: { articles in
                                if !articles.isEmpty {
                                    savedArticles = articles
                                    observer.onNext(articles)
                                }
                                
                            }, onError: { error in
                                observer.onError(error)
                            }
                        )
                )
                
                disposables.append(
                    self.fetchArticlesFromApi()
                        .subscribe(
                            on: ConcurrentDispatchQueueScheduler.init(
                                queue: DispatchQueue.global()
                            )
                        )
                        .subscribe(
                            onNext: { articles in
                                observer.onNext(
                                    articles.filter({ item in
                                        return !savedArticles.contains { savedItem in
                                            savedItem.title == item.title
                                        }
                                    })
                                )
                                
                            }, onError: { error in
                                observer.onError(error)
                            }
                        )
                )
            }
            
            return Disposables.create {
                disposables.forEach { disposable in
                    disposable.dispose()
                }
            }
        }
    }
    
    private func fetchArticlesFromApi() -> Observable<[ApiArticleItem]> {
        return Observable<[ApiArticleItem]>.create { observer in
            if let url = URL(string: NewsDataSource.newsEndpoint) {
                
                AF.request(url, method: .get).response { response in
                    if let error = response.error {
                        observer.onError(error)
                    } else if let data = response.data {
                        let aPINewsResult = try? JSONDecoder().decode(APINewsResult.self, from: data)
                        
                        observer.onNext(
                            aPINewsResult?.articles ?? []
                        )
                    } else {
                        observer.onError(UnexpectedError("can't parse stock endpoint"))
                    }
                    
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
        
    }
}

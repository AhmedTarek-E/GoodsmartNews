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
            var disposable: Disposable?
            if let url = URL(string: NewsDataSource.newsEndpoint) {
                
                AF.request(url, method: .get).response { [weak self] response in
                    guard let self = self else { return }
                    if let error = response.error {
                        observer.onError(error)
                    } else if let data = response.data {
                        let aPINewsResult = try? JSONDecoder().decode(APINewsResult.self, from: data)
                        let articles = aPINewsResult?.articles ?? []
                        
                        disposable = self.saveToDatabase(articles: articles).subscribe(
                            onNext: { _ in
                                observer.onNext(articles)
                                observer.onCompleted()
                            },
                            onError: { error in
                                observer.onError(error)
                            }
                        )
                        
                    } else {
                        observer.onError(UnexpectedError("can't parse news endpoint"))
                    }
                    
                }
            }
            
            return Disposables.create {
                disposable?.dispose()
            }
        }
        
    }
    
    private func saveToDatabase(
        articles: [ApiArticleItem]
    ) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer in
            var disposables = [Disposable]()
            
            if let self = self {
                disposables.append(
                    self.database.getArticles()
                        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
                        .subscribe { entities in
                            if entities.isEmpty {
                                let items = Array(articles.prefix(10))
                                
                                let observables = items.map { item in
                                    return self.database.insertArticle(article: item)
                                }
                                var count = 0
                                disposables.append(
                                    Observable.concat(observables)
                                        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
                                        .subscribe { _ in
                                            count += 1
                                            if count == observables.count {
                                                observer.onNext(())
                                                observer.onCompleted()
                                            }
                                        } onError: { error in
                                            observer.onError(error)
                                        }
                                )
                                
                            } else {
                                observer.onNext(())
                                observer.onCompleted()
                            }
                        } onError: { error in
                            observer.onError(error)
                        }
                )
                
            }
            

            return Disposables.create {
                disposables.forEach { disposable in
                    disposable.dispose()
                }
            }
        }
    }
}

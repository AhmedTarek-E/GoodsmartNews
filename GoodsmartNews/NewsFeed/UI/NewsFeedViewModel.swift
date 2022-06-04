//
//  NewsFeedViewModel.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 04/06/2022.
//

import Foundation
import RxSwift

class NewsFeedViewModel {
    init(getStockTickersUseCase: GetStockTickersUseCase, getNewsUseCase: GetNewsUseCase) {
        self.getStockTickersUseCase = getStockTickersUseCase
        self.getNewsUseCase = getNewsUseCase
    }
    
    private let getStockTickersUseCase: GetStockTickersUseCase
    private let getNewsUseCase: GetNewsUseCase
    
    private let disposeBag = DisposeBag()
    
    private let stateSubject = BehaviorSubject(value: NewsFeedState.initial())
    
    private let effectSubject = PublishSubject<NewsFeedEffect>()
    
    var state: Observable<NewsFeedState> {
        return stateSubject.asObservable()
    }
    
    var effect: Observable<NewsFeedEffect> {
        return effectSubject.asObservable()
    }
    
    var currentState: NewsFeedState {
        let unwrapped = try? stateSubject.value()
        return unwrapped ?? .initial()
    }
    
    func loadData() {
        stateSubject.onNext(
            currentState.reduce(
                stockTickers: .loading,
                news: .loading
            )
        )
        
        Observable.combineLatest(
            getStockTickersUseCase.execute(),
            getNewsUseCase.execute()
        )
        .subscribe(
            on: ConcurrentDispatchQueueScheduler(
                queue: .global()
            )
        )
        .subscribe { [weak self] (stockTickers, articles) in
            guard let self = self else { return }
            self.stateSubject.onNext(
                self.currentState.reduce(
                    stockTickers: .success(data: stockTickers),
                    news: .success(data: articles)
                )
            )
        } onError: { [weak self] error in
            guard let self = self else { return }
            
            let errorMessage: String
            if let error = error as? OperationError {
                errorMessage = error.errorDescription ?? "Unexpected Error"
            } else {
                errorMessage = "Something went wrong"
            }
            self.stateSubject.onNext(
                self.currentState.reduce(
                    stockTickers: .failure(error: errorMessage),
                    news: .failure(error: errorMessage)
                )
            )
            
            self.effectSubject.onNext(.showError(message: errorMessage))
        }
        .disposed(by: disposeBag)

    }
}

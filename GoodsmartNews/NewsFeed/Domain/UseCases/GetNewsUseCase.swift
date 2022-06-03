//
//  GetNewsUseCase.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation
import RxSwift

protocol GetNewsUseCase {
    func execute() -> Observable<[Article]>
}

class GetNewsUseCaseImp: GetNewsUseCase {
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    let repository: NewsRepository
    
    func execute() -> Observable<[Article]> {
        return repository.getNewsArticles()
    }
}

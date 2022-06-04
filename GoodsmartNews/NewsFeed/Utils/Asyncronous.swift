//
//  Asyncronous.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 04/06/2022.
//

import Foundation

enum Asyncronous<T>: Equatable {
    static func == (lhs: Asyncronous<T>, rhs: Asyncronous<T>) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial),
            (.loading, .loading),
            (.failure, .failure),
            (.success, .success):
            return true
            
        default:
            return false
        }
    }
    
    case initial
    case loading
    case failure(error: String)
    case success(data: T)
}

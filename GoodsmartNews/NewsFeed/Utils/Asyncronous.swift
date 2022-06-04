//
//  Asyncronous.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 04/06/2022.
//

import Foundation

enum Asyncronous<T> {
    case initial
    case loading
    case failure(error: String)
    case success(data: T)
}

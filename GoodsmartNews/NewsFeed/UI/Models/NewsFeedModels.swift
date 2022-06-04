//
//  NewsFeedModels.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 04/06/2022.
//

import Foundation

enum NewsFeedSection: Int, CaseIterable {
    case stocks = 0
    case latestNews = 1
    case moreNews = 2
}

extension NewsFeedSection {
    var title: String {
        switch self {
        case .stocks:
            return "Stocks"
        case .latestNews:
            return "Latest News"
        case .moreNews:
            return "More News"
        }
    }
}

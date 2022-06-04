//
//  ArticleMapper.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation

extension ApiArticleItem {
    func map() -> Article {
        let formatter = ISO8601DateFormatter()
        return Article(
            title: title ?? "",
            description: articleDescription ?? "",
            image: urlToImage ?? "",
            url: url ?? "",
            publishedAt: formatter.date(from: publishedAt ?? "") ?? Date.now
        )
    }
}

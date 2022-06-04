//
//  ArticleMapper.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation

extension ApiArticleItem {
    func map() -> Article {
        return Article(
            title: title ?? "",
            description: articleDescription ?? "",
            image: urlToImage ?? "",
            url: url ?? "",
            publishedAt: publishedAt ?? Date.now
        )
    }
}

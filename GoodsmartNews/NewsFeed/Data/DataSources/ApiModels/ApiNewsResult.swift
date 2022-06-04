//
//  ApiNewsResult.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation

// MARK: - APINewsResult
struct APINewsResult: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [ApiArticleItem]?
}

// MARK: - Article
struct ApiArticleItem: Codable {
    let author: String?
    let title, articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

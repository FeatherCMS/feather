//
//  ReadArticle.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherContracts

public struct ReadArticle: Scope {
    public let article: any ArticleQueries

    public init(article: any ArticleQueries) {
        self.article = article
    }
}

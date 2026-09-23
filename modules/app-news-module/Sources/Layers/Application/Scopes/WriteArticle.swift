//
//  WriteArticle.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherContracts
public import NewsDomain

public struct WriteArticle: Scope {
    public let article: any ArticleRepository

    public init(article: any ArticleRepository) {
        self.article = article
    }
}

//
//  WriteArticle.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import NewsModule
public import NewsDomain

public struct WriteArticle: Scope {
    public let article: any Article.Repository.Interface

    public init(article: any Article.Repository.Interface) {
        self.article = article
    }
}

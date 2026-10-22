//
//  ReadPublicNewsArticle.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import WebApplication
public import WebDomain

public struct ReadPublicNewsArticle: Scope {
    public let article: any ArticleQueries
    public let category: any CategoryQueries
    public let metadata: any Metadata.Query.Interface

    public init(
        article: any ArticleQueries,
        category: any CategoryQueries,
        metadata: any Metadata.Query.Interface
    ) {
        self.article = article
        self.category = category
        self.metadata = metadata
    }
}

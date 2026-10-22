//
//  ReadPublicNewsCategory.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import WebApplication
public import WebDomain

public struct ReadPublicNewsCategory: Scope {
    public let category: any CategoryQueries
    public let article: any ArticleQueries
    public let metadata: any Metadata.Query.Interface

    public init(
        category: any CategoryQueries,
        article: any ArticleQueries,
        metadata: any Metadata.Query.Interface
    ) {
        self.category = category
        self.article = article
        self.metadata = metadata
    }
}

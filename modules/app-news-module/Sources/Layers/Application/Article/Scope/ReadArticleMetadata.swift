//
//  ReadArticleMetadata.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import WebApplication
public import WebDomain

public struct ReadArticleMetadata: Scope {
    public let article: any ArticleQueries
    public let metadata: any Metadata.Query.Interface

    public init(
        article: any ArticleQueries,
        metadata: any Metadata.Query.Interface
    ) {
        self.article = article
        self.metadata = metadata
    }
}

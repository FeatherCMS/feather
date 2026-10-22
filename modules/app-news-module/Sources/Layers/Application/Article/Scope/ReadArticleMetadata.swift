//
//  ReadArticleMetadata.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

public struct ReadArticleMetadata: Scope {
    public let article: any ArticleQueries
    public let metadata: any WebModule.Metadata.Query.Interface

    public init(
        article: any ArticleQueries,
        metadata: any WebModule.Metadata.Query.Interface
    ) {
        self.article = article
        self.metadata = metadata
    }
}

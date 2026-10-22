//
//  ReadPublicNewsArticle.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

public struct ReadPublicNewsArticle: Scope {
    public let article: any ArticleQueries
    public let category: any CategoryQueries
    public let metadata: any WebModule.Metadata.Query.Interface

    public init(
        article: any ArticleQueries,
        category: any CategoryQueries,
        metadata: any WebModule.Metadata.Query.Interface
    ) {
        self.article = article
        self.category = category
        self.metadata = metadata
    }
}

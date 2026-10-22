//
//  ReadPublicNewsCategory.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

public struct ReadPublicNewsCategory: Scope {
    public let category: any CategoryQueries
    public let article: any ArticleQueries
    public let metadata: any WebModule.Metadata.Query.Interface

    public init(
        category: any CategoryQueries,
        article: any ArticleQueries,
        metadata: any WebModule.Metadata.Query.Interface
    ) {
        self.category = category
        self.article = article
        self.metadata = metadata
    }
}

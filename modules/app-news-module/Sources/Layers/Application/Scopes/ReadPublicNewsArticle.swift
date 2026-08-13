//
//  ReadPublicNewsArticle.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import NewsDomain
import WebApplication

public struct ReadPublicNewsArticle: Scope {
    public let article: any ArticleQueries
    public let category: any CategoryQueries
    public let metadata: any MetadataQueries

    public init(
        article: any ArticleQueries,
        category: any CategoryQueries,
        metadata: any MetadataQueries
    ) {
        self.article = article
        self.category = category
        self.metadata = metadata
    }
}

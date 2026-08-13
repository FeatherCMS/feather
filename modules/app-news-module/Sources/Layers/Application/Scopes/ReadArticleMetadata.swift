//
//  ReadArticleMetadata.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import NewsDomain
import WebApplication

public struct ReadArticleMetadata: Scope {
    public let article: any ArticleQueries
    public let metadata: any MetadataQueries

    public init(
        article: any ArticleQueries,
        metadata: any MetadataQueries
    ) {
        self.article = article
        self.metadata = metadata
    }
}

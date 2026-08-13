//
//  ReadPublicNewsCategory.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import NewsDomain
import WebApplication

public struct ReadPublicNewsCategory: Scope {
    public let category: any CategoryQueries
    public let article: any ArticleQueries
    public let metadata: any MetadataQueries

    public init(
        category: any CategoryQueries,
        article: any ArticleQueries,
        metadata: any MetadataQueries
    ) {
        self.category = category
        self.article = article
        self.metadata = metadata
    }
}

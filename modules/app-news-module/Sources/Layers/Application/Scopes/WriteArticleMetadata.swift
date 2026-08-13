//
//  WriteArticleMetadata.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import NewsDomain
import SystemApplication
import WebDomain

public struct WriteArticleMetadata: Scope {
    public let article: any ArticleRepository
    public let metadata: any MetadataRepository
    public let variable: any VariableQueries

    public init(
        article: any ArticleRepository,
        metadata: any MetadataRepository,
        variable: any VariableQueries
    ) {
        self.article = article
        self.metadata = metadata
        self.variable = variable
    }
}

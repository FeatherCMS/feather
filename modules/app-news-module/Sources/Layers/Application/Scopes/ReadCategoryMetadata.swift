//
//  ReadCategoryMetadata.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import NewsDomain
import WebApplication

public struct ReadCategoryMetadata: Scope {
    public let category: any CategoryQueries
    public let metadata: any MetadataQueries

    public init(
        category: any CategoryQueries,
        metadata: any MetadataQueries
    ) {
        self.category = category
        self.metadata = metadata
    }
}

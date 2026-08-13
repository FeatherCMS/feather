//
//  WriteCategoryMetadata.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import NewsDomain
import SystemApplication
import WebDomain

public struct WriteCategoryMetadata: Scope {
    public let category: any CategoryRepository
    public let metadata: any MetadataRepository
    public let variable: any VariableQueries

    public init(
        category: any CategoryRepository,
        metadata: any MetadataRepository,
        variable: any VariableQueries
    ) {
        self.category = category
        self.metadata = metadata
        self.variable = variable
    }
}

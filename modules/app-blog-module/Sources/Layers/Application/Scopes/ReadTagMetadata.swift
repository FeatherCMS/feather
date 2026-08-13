//
//  ReadTagMetadata.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherApplication
import FeatherContracts
import WebApplication

public struct ReadTagMetadata: Scope {
    public let tag: any TagQueries
    public let metadata: any MetadataQueries

    public init(
        tag: any TagQueries,
        metadata: any MetadataQueries
    ) {
        self.tag = tag
        self.metadata = metadata
    }
}

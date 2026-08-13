//
//  ReadPostMetadata.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherApplication
import FeatherContracts
import WebApplication

public struct ReadPostMetadata: Scope {
    public let post: any PostQueries
    public let metadata: any MetadataQueries

    public init(
        post: any PostQueries,
        metadata: any MetadataQueries
    ) {
        self.post = post
        self.metadata = metadata
    }
}

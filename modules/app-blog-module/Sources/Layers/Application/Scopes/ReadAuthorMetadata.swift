//
//  ReadAuthorMetadata.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherApplication
import FeatherContracts
import WebApplication

public struct ReadAuthorMetadata: Scope {
    public let author: any AuthorQueries
    public let metadata: any MetadataQueries

    public init(
        author: any AuthorQueries,
        metadata: any MetadataQueries
    ) {
        self.author = author
        self.metadata = metadata
    }
}

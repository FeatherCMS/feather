//
//  ReadPublic.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherApplication
import FeatherContracts
import WebApplication

public struct ReadPublic: Scope {
    public let post: any PostQueries
    public let author: any AuthorQueries
    public let tag: any TagQueries
    public let authorLink: any AuthorLinkQueries
    public let metadata: any MetadataQueries

    public init(
        post: any PostQueries,
        author: any AuthorQueries,
        tag: any TagQueries,
        authorLink: any AuthorLinkQueries,
        metadata: any MetadataQueries
    ) {
        self.post = post
        self.author = author
        self.tag = tag
        self.authorLink = authorLink
        self.metadata = metadata
    }
}

//
//  ReadPublicBlogPost.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import BlogDomain
import WebApplication

public struct ReadPublicBlogPost: Scope {
    public let post: any PostQueries
    public let author: any AuthorQueries
    public let tag: any TagQueries
    public let metadata: any MetadataQueries

    public init(
        post: any PostQueries,
        author: any AuthorQueries,
        tag: any TagQueries,
        metadata: any MetadataQueries
    ) {
        self.post = post
        self.author = author
        self.tag = tag
        self.metadata = metadata
    }
}

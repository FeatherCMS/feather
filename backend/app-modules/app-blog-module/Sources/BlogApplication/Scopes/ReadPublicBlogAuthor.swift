//
//  ReadPublicBlogAuthor.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import BlogDomain
import WebApplication

public struct ReadPublicBlogAuthor: Scope {
    public let author: any AuthorQueries
    public let post: any PostQueries
    public let authorLink: any AuthorLinkQueries
    public let metadata: any MetadataQueries

    public init(
        author: any AuthorQueries,
        post: any PostQueries,
        authorLink: any AuthorLinkQueries,
        metadata: any MetadataQueries
    ) {
        self.author = author
        self.post = post
        self.authorLink = authorLink
        self.metadata = metadata
    }
}

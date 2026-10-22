//
//  Public.Query.Scope.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogModule
public import FeatherModuleKit
public import WebApplication
public import WebDomain

extension Public {
    public enum Query {}
}

extension Public.Query {
    public struct Scope: FeatherModuleKit.Scope {
        public let post: any Post.Query.Interface
        public let author: any Author.Query.Interface
        public let tag: any Tag.Query.Interface
        public let authorLink: any AuthorLink.Query.Interface
        public let metadata: any Metadata.Query.Interface

        public init(
            post: any Post.Query.Interface,
            author: any Author.Query.Interface,
            tag: any Tag.Query.Interface,
            authorLink: any AuthorLink.Query.Interface,
            metadata: any Metadata.Query.Interface
        ) {
            self.post = post
            self.author = author
            self.tag = tag
            self.authorLink = authorLink
            self.metadata = metadata
        }
    }
}

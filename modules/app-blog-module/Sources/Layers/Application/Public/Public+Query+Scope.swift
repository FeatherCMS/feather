//
//  Public.Query.Scope.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import WebApplication
public import WebDomain

extension Public {
    public enum Query {}
}

extension Public.Query {
    public struct Scope: FeatherModuleKit.Scope {
        public let post: any Public.Query.PostContent.Interface
        public let author: any Public.Query.AuthorContent.Interface
        public let tag: any Public.Query.TagContent.Interface
        public let authorLink: any Public.Query.AuthorLinkContent.Interface
        public let metadata: any Metadata.Query.Interface

        public init(
            post: any Public.Query.PostContent.Interface,
            author: any Public.Query.AuthorContent.Interface,
            tag: any Public.Query.TagContent.Interface,
            authorLink: any Public.Query.AuthorLinkContent.Interface,
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

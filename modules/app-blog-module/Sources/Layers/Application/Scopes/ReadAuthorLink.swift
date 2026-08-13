//
//  ReadAuthorLink.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherApplication
import FeatherContracts

public struct ReadAuthorLink: Scope {
    public let authorLink: any AuthorLinkQueries

    public init(authorLink: any AuthorLinkQueries) {
        self.authorLink = authorLink
    }
}

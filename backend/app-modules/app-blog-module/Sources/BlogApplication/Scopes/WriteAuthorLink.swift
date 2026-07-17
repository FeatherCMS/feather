//
//  WriteAuthorLink.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import BlogDomain

public struct WriteAuthorLink: Scope {
    public let authorLink: any AuthorLinkRepository

    public init(authorLink: any AuthorLinkRepository) {
        self.authorLink = authorLink
    }
}

//
//  ReadAuthor.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import BlogDomain

public struct ReadAuthor: Scope {
    public let author: any AuthorQueries

    public init(author: any AuthorQueries) {
        self.author = author
    }
}

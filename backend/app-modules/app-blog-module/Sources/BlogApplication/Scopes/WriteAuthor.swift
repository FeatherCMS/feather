//
//  WriteAuthor.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import BlogDomain

public struct WriteAuthor: Scope {
    public let author: any AuthorRepository

    public init(author: any AuthorRepository) {
        self.author = author
    }
}

//
//  WritePost.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import BlogDomain

public struct WritePost: Scope {
    public let post: any PostRepository

    public init(post: any PostRepository) {
        self.post = post
    }
}

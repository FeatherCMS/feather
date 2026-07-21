//
//  ReadPost.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import BlogDomain

public struct ReadPost: Scope {
    public let post: any PostQueries

    public init(post: any PostQueries) {
        self.post = post
    }
}

//
//  WriteTag.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import BlogDomain

public struct WriteTag: Scope {
    public let tag: any TagRepository

    public init(tag: any TagRepository) {
        self.tag = tag
    }
}

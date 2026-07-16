//
//  ReadTag.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import BlogDomain

public struct ReadTag: Scope {
    public let tag: any TagQueries

    public init(tag: any TagQueries) {
        self.tag = tag
    }
}

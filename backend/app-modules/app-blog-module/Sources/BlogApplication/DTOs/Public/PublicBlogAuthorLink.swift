//
//  PublicBlogAuthorLink.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application

public struct PublicBlogAuthorLink: DTO {
    public let label: String
    public let url: String
    public let isBlank: Bool

    public init(
        label: String,
        url: String,
        isBlank: Bool
    ) {
        self.label = label
        self.url = url
        self.isBlank = isBlank
    }
}

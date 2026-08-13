//
//  SettingsDetail.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts

public struct SettingsDetail: DTO {
    public let postListPath: String
    public let authorListPath: String
    public let tagListPath: String
    public let postPathPrefix: String
    public let authorPathPrefix: String
    public let tagPathPrefix: String

    package init(
        postListPath: String,
        authorListPath: String,
        tagListPath: String,
        postPathPrefix: String,
        authorPathPrefix: String,
        tagPathPrefix: String
    ) {
        self.postListPath = postListPath
        self.authorListPath = authorListPath
        self.tagListPath = tagListPath
        self.postPathPrefix = postPathPrefix
        self.authorPathPrefix = authorPathPrefix
        self.tagPathPrefix = tagPathPrefix
    }
}

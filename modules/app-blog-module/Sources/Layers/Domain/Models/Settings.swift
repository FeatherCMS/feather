//
//  Settings.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

public struct Settings: Model {

    public enum Error: DomainError {
        case pathTooLong
    }

    public var postListPath: String
    public var authorListPath: String
    public var tagListPath: String
    public var postPathPrefix: String
    public var authorPathPrefix: String
    public var tagPathPrefix: String

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

extension Settings {
    private static func validate(
        postListPath: String,
        authorListPath: String,
        tagListPath: String,
        postPathPrefix: String,
        authorPathPrefix: String,
        tagPathPrefix: String
    ) throws(Self.Error) {
        let values = [
            postListPath,
            authorListPath,
            tagListPath,
            postPathPrefix,
            authorPathPrefix,
            tagPathPrefix,
        ]
        guard values.allSatisfy({ $0.count < 255 }) else {
            throw .pathTooLong
        }
    }

    public mutating func update(
        postListPath: String,
        authorListPath: String,
        tagListPath: String,
        postPathPrefix: String,
        authorPathPrefix: String,
        tagPathPrefix: String
    ) throws(Self.Error) {
        try Self.validate(
            postListPath: postListPath,
            authorListPath: authorListPath,
            tagListPath: tagListPath,
            postPathPrefix: postPathPrefix,
            authorPathPrefix: authorPathPrefix,
            tagPathPrefix: tagPathPrefix
        )
        self.postListPath = postListPath
        self.authorListPath = authorListPath
        self.tagListPath = tagListPath
        self.postPathPrefix = postPathPrefix
        self.authorPathPrefix = authorPathPrefix
        self.tagPathPrefix = tagPathPrefix
    }
}

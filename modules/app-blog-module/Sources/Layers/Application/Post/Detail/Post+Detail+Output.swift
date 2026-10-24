//
//  Post.Detail.Output.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogModule
public import FeatherApplication
public import WebApplication
import WebDomain
public import WebModule

public import struct Foundation.Date

extension Post.Detail {
    public struct Output: DTO {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let authorIds: [String]
        public let tagIds: [String]
        public let metadata: WebModule.Metadata.Snapshot
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            authorIds: [String],
            tagIds: [String],
            metadata: WebModule.Metadata.Snapshot,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.authorIds = authorIds
            self.tagIds = tagIds
            self.metadata = metadata
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}

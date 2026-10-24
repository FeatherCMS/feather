//
//  Post+List+Output.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogModule
public import FeatherApplication

public import struct Foundation.Date

extension Post.List {
    public struct Output: DTO {

        public struct Item: Sendable {
            public let id: String
            public let title: String
            public let excerpt: String
            public let imageAssetId: String?
            public let createdAt: Date
            public let updatedAt: Date

            package init(
                id: String,
                title: String,
                excerpt: String,
                imageAssetId: String?,
                createdAt: Date,
                updatedAt: Date
            ) {
                self.id = id
                self.title = title
                self.excerpt = excerpt
                self.imageAssetId = imageAssetId
                self.createdAt = createdAt
                self.updatedAt = updatedAt
            }
        }

        public let items: [Item]

        public init(items: [Item]) {
            self.items = items
        }
    }
}

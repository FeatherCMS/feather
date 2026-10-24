//
//  AuthorLink.List.Output.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogModule
public import FeatherApplication

public import struct Foundation.Date

extension AuthorLink.List {
    public struct Output: DTO {

        public struct Item: Sendable {
            public let id: String
            public let authorId: String
            public let label: String
            public let url: String
            public let priority: Int
            public let isBlank: Bool
            public let permission: String
            public let createdAt: Date
            public let updatedAt: Date

            package init(
                id: String,
                authorId: String,
                label: String,
                url: String,
                priority: Int,
                isBlank: Bool,
                permission: String,
                createdAt: Date,
                updatedAt: Date
            ) {
                self.id = id
                self.authorId = authorId
                self.label = label
                self.url = url
                self.priority = priority
                self.isBlank = isBlank
                self.permission = permission
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

//
//  File.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 17..
//

import Application
import struct Foundation.Date

public struct SessionList: DTO {

    public struct Item: Sendable {
        public let id: String
        public let token: String
        public let accountId: String
        public var expiresAt: Double
        public let isPersistent: Bool
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            token: String,
            accountId: String,
            expiresAt: Double,
            isPersistent: Bool,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.token = token
            self.accountId = accountId
            self.expiresAt = expiresAt
            self.isPersistent = isPersistent
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }

    public struct Query: Sendable {

        public struct Sort: Sendable {
            public enum Field: String, Sendable, CaseIterable {
                case id
            }

            public var field: Field
            public var direction: Search.SortDirection

            public init(
                field: Field,
                direction: Search.SortDirection
            ) {
                self.field = field
                self.direction = direction
            }
        }

        public var page: Search.Page
        public var sort: [Sort]
        public var search: String?
        public var accountId: String?

        public init(
            page: Search.Page = .init(),
            sort: [Sort] = [],
            search: String? = nil,
            accountId: String? = nil
        ) {
            self.page = page
            self.sort = sort
            self.search = search
            self.accountId = accountId
        }
    }

    public let items: [Item]

    public init(
        items: [Item]
    ) {
        self.items = items
    }

}

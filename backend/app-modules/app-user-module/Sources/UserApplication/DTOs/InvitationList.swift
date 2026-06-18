//
//  File.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 17..
//

import Application
import struct Foundation.Date

public struct InvitationList: DTO {

    public struct Item: Sendable {
        public let id: String
        public let email: String
        public let token: String
        // TODO: isUsed?
        public let expiresAt: Date
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            email: String,
            token: String,
            expiresAt: Date,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.email = email
            self.token = token
            self.expiresAt = expiresAt
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

        public init(
            page: Search.Page = .init(),
            sort: [Sort] = [],
            search: String? = nil
        ) {
            self.page = page
            self.sort = sort
            self.search = search
        }
    }

    public let items: [Item]

    public init(
        items: [Item]
    ) {
        self.items = items
    }

}

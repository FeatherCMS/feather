//
//  IdentityList.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 17.
//

import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct IdentityList: DTO {

    public struct Item: Sendable {
        public let id: String
        public var status: IdentityStatus
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            status: IdentityStatus,
            createdAt: Date,
            updatedAt: Date,
        ) {
            self.id = id
            self.status = status
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

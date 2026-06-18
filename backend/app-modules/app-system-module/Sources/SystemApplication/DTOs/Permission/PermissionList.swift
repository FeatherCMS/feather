//
//  File.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

import Application
import struct Foundation.Date

public struct PermissionList: DTO {

    public struct Item: Sendable {
        public let id: String
        public let name: String
        public let notes: String
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            name: String,
            notes: String,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.name = name
            self.notes = notes
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }

    public struct Query: Sendable {

        public struct Sort: Sendable {
            public enum Field: String, Sendable, CaseIterable {
                case id
                case name
                case notes
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

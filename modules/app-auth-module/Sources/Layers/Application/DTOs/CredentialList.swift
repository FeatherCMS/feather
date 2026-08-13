//
//  CredentialList.swift
//  app-auth-module
//

import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct CredentialList: DTO {

    public struct Item: Sendable {
        public let id: String
        public let userId: String
        public let email: String
        public let isPersistent: Bool
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            userId: String,
            email: String,
            isPersistent: Bool,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.userId = userId
            self.email = email
            self.isPersistent = isPersistent
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }

    public struct Query: Sendable {

        public struct Sort: Sendable {
            public enum Field: String, Sendable, CaseIterable {
                case userId
                case email
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

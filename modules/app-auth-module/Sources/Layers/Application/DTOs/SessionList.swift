//
//  SessionList.swift
//  app-auth-module
//
//  Created by Tibor Bödecs on 2026. 04. 17.
//

import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct SessionList: DTO {

    public struct Item: Sendable {
        public let id: String
        public let token: String
        public let identityId: String
        public let authenticationType: String
        public let authenticationReference: String
        public var expiresAt: Double
        public let isPersistent: Bool
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            token: String,
            identityId: String,
            authenticationType: String,
            authenticationReference: String,
            expiresAt: Double,
            isPersistent: Bool,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.token = token
            self.identityId = identityId
            self.authenticationType = authenticationType
            self.authenticationReference = authenticationReference
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
        public var identityId: String?

        public init(
            page: Search.Page = .init(),
            sort: [Sort] = [],
            search: String? = nil,
            identityId: String? = nil
        ) {
            self.page = page
            self.sort = sort
            self.search = search
            self.identityId = identityId
        }
    }

    public let items: [Item]

    public init(
        items: [Item]
    ) {
        self.items = items
    }

}

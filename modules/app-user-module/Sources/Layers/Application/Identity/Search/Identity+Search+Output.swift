//
//  Identity+Search+Output.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 17.
//

public import FeatherApplication
public import UserDomain
public import UserModule

public import struct Foundation.Date

extension Identity.Search {
    public struct Output: DTO {

        public struct Item: Sendable {
            public let id: String
            public let name: String
            public var status: Identity.Model.Status
            public let roles: [String]
            public let createdAt: Date
            public let updatedAt: Date

            package init(
                id: String,
                name: String,
                status: Identity.Model.Status,
                roles: [String],
                createdAt: Date,
                updatedAt: Date,
            ) {
                self.id = id
                self.name = name
                self.status = status
                self.roles = roles
                self.createdAt = createdAt
                self.updatedAt = updatedAt
            }
        }

        public let items: [Item]
        public let total: Int

        public init(
            items: [Item],
            total: Int
        ) {
            self.items = items
            self.total = total
        }

    }

}

//
//  Role+Search+Output.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import UserModule

public import struct Foundation.Date

extension Role.Search {
    public struct Output: DTO {

        public struct Item: Sendable {
            public let id: String
            public let key: String
            public var name: String?
            public var notes: String?
            public let createdAt: Date
            public let updatedAt: Date

            package init(
                id: String,
                key: String,
                name: String?,
                notes: String?,
                createdAt: Date,
                updatedAt: Date
            ) {
                self.id = id
                self.key = key
                self.name = name
                self.notes = notes
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

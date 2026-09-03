//
//  Identity.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 07. 16.

import FeatherDomain

import struct Foundation.Date

public struct Identity: Model {
    public struct New: Sendable {
        public let name: String
        public let status: Status
        public let isRoot: Bool
    }

    public enum Status: String, Sendable, CaseIterable, Codable {
        case invited
        case active
        case suspended
        case deactivated
        case anonymized
    }

    public let id: String
    public var name: String
    public var status: Status
    public let isRoot: Bool
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        name: String = "User",
        status: Status,
        isRoot: Bool,
        createdAt: Date,
        updatedAt: Date,
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.isRoot = isRoot
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Identity {

    public static func create(
        name: String = "User",
        status: Status,
        isRoot: Bool = false
    ) -> Self.New {
        .init(
            name: name,
            status: status,
            isRoot: isRoot
        )
    }

    public mutating func update(
        name: String? = nil,
        status: Identity.Status? = nil
    ) {
        self.name = name ?? self.name
        self.status = status ?? self.status
    }
}

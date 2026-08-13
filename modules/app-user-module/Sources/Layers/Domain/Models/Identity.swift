//
//  Identity.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 07. 16.

import FeatherDomain

import struct Foundation.Date

public struct Identity: Model {
    public struct New: Sendable {
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
    public var status: Status
    public let isRoot: Bool
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        status: Status,
        isRoot: Bool,
        createdAt: Date,
        updatedAt: Date,
    ) {
        self.id = id
        self.status = status
        self.isRoot = isRoot
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Identity {

    public static func create(
        status: Status,
        isRoot: Bool = false
    ) -> Self.New {
        .init(
            status: status,
            isRoot: isRoot
        )
    }

    public mutating func update(
        status: Identity.Status? = nil
    ) {
        self.status = status ?? self.status
    }
}

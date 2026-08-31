//
//  Invitation.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 07. 16.

import FeatherDomain

import struct Foundation.Date

public struct Invitation: Model {

    public enum Error: DomainError {
        case emailTooShort
        case emailTooLong
        case tokenTooShort
        case tokenTooLong

        case alreadyUsed
        case expired
    }

    public static let lifetime: Double = 86_400

    public struct New: Sendable {
        public let userId: String
        public let email: String
        public let token: String
        public let roleIDs: [String]
        public let expiresAtInterval: Double
    }

    public let id: String
    public let userId: String
    public let email: String
    public let token: String
    public let roleIDs: [String]
    public let expiresAt: Date
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        userId: String,
        email: String,
        token: String,
        roleIDs: [String],
        expiresAt: Date,
        createdAt: Date,
        updatedAt: Date,
    ) {
        self.id = id
        self.userId = userId
        self.email = email
        self.token = token
        self.roleIDs = roleIDs
        self.expiresAt = expiresAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Invitation {

    package init(
        id: String,
        email: String,
        token: String,
        roleIDs: [String] = [],
        expiresAt: Date,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.init(
            id: id,
            userId: id,
            email: email,
            token: token,
            roleIDs: roleIDs,
            expiresAt: expiresAt,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    private static func validate(
        email: String
    ) throws(Self.Error) {
        guard email.count > 3 else {
            throw .emailTooShort
        }
        guard email.count < 255 else {
            throw .emailTooLong
        }
    }

    private static func validate(
        token: String
    ) throws(Self.Error) {
        guard token.count > 8 else {
            throw .tokenTooShort
        }
        guard token.count < 255 else {
            throw .tokenTooLong
        }
    }

    public static func create(
        userId: String,
        email: String,
        token: String,
        roleIDs: [String] = []
    ) throws(Self.Error) -> Self.New {
        try validate(email: email)
        try validate(token: token)

        return .init(
            userId: userId,
            email: email,
            token: token,
            roleIDs: roleIDs,
            expiresAtInterval: lifetime
        )
    }

    public mutating func update(
        email: String?,
        roleIDs: [String]? = nil
    ) throws(Self.Error) {
        let updatedEmail = email ?? self.email
        guard email != nil || roleIDs != nil else {
            return
        }

        try Self.validate(email: updatedEmail)
        self = .init(
            id: id,
            userId: userId,
            email: updatedEmail,
            token: token,
            roleIDs: roleIDs ?? self.roleIDs,
            expiresAt: expiresAt,
            createdAt: createdAt,
            updatedAt: .init()
        )
    }

    public mutating func renew(
        token: String,
        expiresAt: Date
    ) throws(Self.Error) {
        try Self.validate(token: token)
        self = .init(
            id: id,
            userId: userId,
            email: email,
            token: token,
            roleIDs: roleIDs,
            expiresAt: expiresAt,
            createdAt: createdAt,
            updatedAt: .init()
        )
    }

    public mutating func consume(
        now: Date = .init()
    ) throws(Self.Error) {
        guard expiresAt > now else {
            throw .expired
        }
    }
}

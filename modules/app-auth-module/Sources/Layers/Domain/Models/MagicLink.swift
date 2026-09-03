//
//  MagicLink.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

import struct Foundation.Date

public struct MagicLink: Model {

    public enum Error: DomainError {
        case identityEmailIdTooShort
        case identityEmailIdTooLong
        case tokenTooShort
        case tokenTooLong

        case alreadyUsed
        case expired
        case invalidToken
    }

    static let lifetime: Double = 3_600

    // MARK: -

    public struct New: Sendable {
        public let identityEmailId: String
        public let token: String
        public let expiresAtInterval: Double
        public let isPersistent: Bool
    }

    public let id: String
    public let identityEmailId: String
    public let token: String
    public let expiresAt: Date
    public let isPersistent: Bool
    public var isUsed: Bool
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        identityEmailId: String,
        token: String,
        expiresAt: Date,
        isPersistent: Bool,
        isUsed: Bool,
        createdAt: Date,
        updatedAt: Date,
    ) {
        self.id = id
        self.identityEmailId = identityEmailId
        self.token = token
        self.expiresAt = expiresAt
        self.isPersistent = isPersistent
        self.isUsed = isUsed
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension MagicLink {

    private static func validate(
        identityEmailId: String
    ) throws(Self.Error) {
        guard identityEmailId.count > 3 else {
            throw .identityEmailIdTooShort
        }
        guard identityEmailId.count < 255 else {
            throw .identityEmailIdTooLong
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
        identityEmailId: String,
        token: String,
        isPersistent: Bool
    ) throws(Self.Error) -> Self.New {
        try validate(identityEmailId: identityEmailId)
        try validate(token: token)

        return .init(
            identityEmailId: identityEmailId,
            token: token,
            expiresAtInterval: lifetime,
            isPersistent: isPersistent
        )
    }

    public mutating func consume(
        now: Date = .init()
    ) throws(Self.Error) {
        guard !self.isUsed else {
            throw .alreadyUsed
        }
        guard expiresAt > now else {
            throw .expired
        }
        self.isUsed = true
    }
}

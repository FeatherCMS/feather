//
//  MagicLink.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

import struct Foundation.Date

public struct MagicLink: Model {

    public enum Error: DomainError {
        case authEmailIdTooShort
        case authEmailIdTooLong
        case tokenTooShort
        case tokenTooLong

        case alreadyUsed
        case expired
        case invalidToken
    }

    static let lifetime: Double = 3_600

    // MARK: -

    public struct New: Sendable {
        public let authEmailId: String
        public let token: String
        public let expiresAtInterval: Double
        public let isPersistent: Bool
    }

    public let id: String
    public let authEmailId: String
    public let token: String
    public let expiresAt: Date
    public let isPersistent: Bool
    public var isUsed: Bool
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        authEmailId: String,
        token: String,
        expiresAt: Date,
        isPersistent: Bool,
        isUsed: Bool,
        createdAt: Date,
        updatedAt: Date,
    ) {
        self.id = id
        self.authEmailId = authEmailId
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
        authEmailId: String
    ) throws(Self.Error) {
        guard authEmailId.count > 3 else {
            throw .authEmailIdTooShort
        }
        guard authEmailId.count < 255 else {
            throw .authEmailIdTooLong
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
        authEmailId: String,
        token: String,
        isPersistent: Bool
    ) throws(Self.Error) -> Self.New {
        try validate(authEmailId: authEmailId)
        try validate(token: token)

        return .init(
            authEmailId: authEmailId,
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

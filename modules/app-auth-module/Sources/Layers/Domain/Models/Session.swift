//
//  Session.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

import struct Foundation.Date

public struct Session: Model {

    public enum Error: DomainError {
        case tokenTooShort
        case tokenTooLong

        case identityIdTooShort
        case identityIdTooLong
        case authenticationTypeTooShort
        case authenticationTypeTooLong
        case invalidAuthenticationType
        case authenticationReferenceTooShort
        case authenticationReferenceTooLong
    }

    public enum Lifetimes {
        public static let regular: Double = 86_400  // 1 day
        public static let persistent: Double = 604_800  // 7 days
    }

    public enum AuthenticationTypes {
        public static let credential = "credential"
        public static let magicLink = "magic_link"
    }

    public struct New: Sendable {
        public let token: String
        public let identityId: String
        public let authenticationType: String
        public let authenticationReference: String
        public let expiresAtInterval: Double
        public let isPersistent: Bool
    }

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
        updatedAt: Date,
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

extension Session {

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

    private static func validate(
        identityId: String
    ) throws(Self.Error) {
        guard identityId.count > 3 else {
            throw .identityIdTooShort
        }
        guard identityId.count < 255 else {
            throw .identityIdTooLong
        }
    }

    private static func validate(
        authenticationType: String
    ) throws(Self.Error) {
        guard authenticationType.count > 0 else {
            throw .authenticationTypeTooShort
        }
        guard authenticationType.count < 255 else {
            throw .authenticationTypeTooLong
        }
        guard
            authenticationType == AuthenticationTypes.credential
                || authenticationType == AuthenticationTypes.magicLink
        else {
            throw .invalidAuthenticationType
        }
    }

    private static func validate(
        authenticationReference: String
    ) throws(Self.Error) {
        guard authenticationReference.count > 0 else {
            throw .authenticationReferenceTooShort
        }
        guard authenticationReference.count < 255 else {
            throw .authenticationReferenceTooLong
        }
    }

    public static func create(
        token: String,
        identityId: String,
        authenticationType: String,
        authenticationReference: String,
        expiresAtInterval: Double,
        isPersistent: Bool
    ) throws(Self.Error) -> Self.New {
        try validate(token: token)
        try validate(identityId: identityId)
        try validate(authenticationType: authenticationType)
        try validate(authenticationReference: authenticationReference)

        return .init(
            token: token,
            identityId: identityId,
            authenticationType: authenticationType,
            authenticationReference: authenticationReference,
            expiresAtInterval: expiresAtInterval,
            isPersistent: isPersistent
        )
    }

    //    mutating func update(
    //        name: String? = nil,
    //        notes: String? = nil
    //    ) throws(Self.Error) {
    //        let newName = name ?? self.name
    //        let newNotes = notes ?? self.notes
    //
    //        try Self.validate(name: newName)
    //        try Self.validate(notes: newNotes)
    //
    //        self.name = newName
    //        self.notes = newNotes
    //    }
}

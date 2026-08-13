//
//  SessionDetail.swift
//  app-auth-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct SessionDetail: DTO {
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

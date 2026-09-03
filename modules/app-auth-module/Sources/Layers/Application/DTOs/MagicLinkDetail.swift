//
//  MagicLinkDetail.swift
//  app-auth-module
//
//  Created by Tibor Bödecs on 2026. 04. 17.
//

import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct MagicLinkDetail: DTO {
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

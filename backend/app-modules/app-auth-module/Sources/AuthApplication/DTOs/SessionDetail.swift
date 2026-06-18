//
//  File.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

import Application
import struct Foundation.Date

public struct SessionDetail: DTO {
    public let id: String
    public let token: String
    public let accountId: String
    public var expiresAt: Double
    public let isPersistent: Bool
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        token: String,
        accountId: String,
        expiresAt: Double,
        isPersistent: Bool,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.token = token
        self.accountId = accountId
        self.expiresAt = expiresAt
        self.isPersistent = isPersistent
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

//
//  InvitationDetail.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct InvitationDetail: DTO {
    public let id: String
    public let userId: String
    public let email: String
    public let token: String
    public let expiresAt: Date
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        userId: String,
        email: String,
        token: String,
        expiresAt: Date,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.userId = userId
        self.email = email
        self.token = token
        self.expiresAt = expiresAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

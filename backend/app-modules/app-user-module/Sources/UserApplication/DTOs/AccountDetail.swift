//
//  File.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

import Application
import struct Foundation.Date

public struct AccountDetail: DTO {
    public let id: String
    public let email: String
    public let roleIds: [String]
    public let status: AccountStatus
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        email: String,
        roleIds: [String] = [],
        status: AccountStatus,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.email = email
        self.roleIds = roleIds
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

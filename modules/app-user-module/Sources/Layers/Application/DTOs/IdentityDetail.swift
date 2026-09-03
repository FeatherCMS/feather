//
//  IdentityDetail.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct IdentityDetail: DTO {
    public let id: String
    public let name: String
    public let roleIds: [String]
    public let status: IdentityStatus
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        id: String,
        name: String,
        roleIds: [String] = [],
        status: IdentityStatus,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.roleIds = roleIds
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

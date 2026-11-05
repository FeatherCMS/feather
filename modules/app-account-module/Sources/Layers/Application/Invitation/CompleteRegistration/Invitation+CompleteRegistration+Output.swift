//
//  Invitation+CompleteRegistration+Output.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

public import AccountModule
public import FeatherApplication
public import UserDomain
public import UserModule

public import struct Foundation.Date

extension Invitation.CompleteRegistration {
    public struct Output: DTO {
        public let id: String
        public let name: String
        public let roleIds: [String]
        public let status: Identity.Model.Status
        public let createdAt: Date
        public let updatedAt: Date

        public init(
            id: String,
            name: String,
            roleIds: [String] = [],
            status: Identity.Model.Status,
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

}

//
//  File.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 17..
//

import Foundation

// Is this a domain model? 🤔
public struct AuthResolvedSession: Sendable {
    public var accountId: String
    public var roles: [String]
    public var permissions: [String]
    public var isPersistent: Bool

    public init(
        accountId: String,
        roles: [String],
        permissions: [String],
        isPersistent: Bool
    ) {
        self.accountId = accountId
        self.roles = roles
        self.permissions = permissions
        self.isPersistent = isPersistent
    }
}

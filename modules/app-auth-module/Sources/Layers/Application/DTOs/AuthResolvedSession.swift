//
//  AuthResolvedSession.swift
//  app-auth-module
//
//  Created by Tibor Bödecs on 2026. 04. 17.
//

import Foundation

// Is this a domain model? 🤔
public struct AuthResolvedSession: Sendable {
    public var identityId: String
    public var roles: [String]
    public var permissions: [String]
    public var isPersistent: Bool

    public init(
        identityId: String,
        roles: [String],
        permissions: [String],
        isPersistent: Bool
    ) {
        self.identityId = identityId
        self.roles = roles
        self.permissions = permissions
        self.isPersistent = isPersistent
    }
}

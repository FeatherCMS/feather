//
//  File.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 08. 11..
//

import FeatherApplication
import FeatherContracts
import UserDomain

public struct WriteIdentityRole: Scope {
    public let identity: any IdentityRepository
    public let role: any RoleRepository

    public init(
        identity: any IdentityRepository,
        role: any RoleRepository
    ) {
        self.identity = identity
        self.role = role
    }
}

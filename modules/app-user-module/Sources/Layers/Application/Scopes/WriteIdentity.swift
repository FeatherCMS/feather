//
//  WriteIdentity.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherContracts
import UserDomain

public struct WriteIdentity: Scope {
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

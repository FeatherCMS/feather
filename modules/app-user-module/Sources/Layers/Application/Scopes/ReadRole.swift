//
//  RoleScopes.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import UserDomain

public struct ReadRole: Scope {
    public let role: any RoleQueries

    public init(
        role: any RoleQueries
    ) {
        self.role = role
    }
}

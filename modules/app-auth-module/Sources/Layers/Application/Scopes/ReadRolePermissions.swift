//
//  ReadRolePermissions.swift
//  app-auth-module
//
//  Created by Tibor Bödecs on 2026. 04. 18.
//

import FeatherApplication
import FeatherContracts
import SystemApplication
import UserApplication

public struct AuthScope: Scope {

    //    public let system: any SystemQueries
    public let identity: any IdentityQueries
    public let rolePermissions: any RolePermissionQueries

    public init(
        identity: any IdentityQueries,
        rolePermissions: any RolePermissionQueries
    ) {
        self.identity = identity
        self.rolePermissions = rolePermissions
    }
}

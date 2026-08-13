//
//  WriteRolePermissions.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import FeatherContracts

public struct WriteRolePermissions: Scope {

    public let rolePermissions: any RolePermissionRepository

    public init(
        rolePermissions: any RolePermissionRepository
    ) {
        self.rolePermissions = rolePermissions
    }
}

//
//  WriteRolePermissions.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import AuthDomain

public struct WriteRolePermissions: Scope {

    public let rolePermissions: any RolePermissionRepository

    public init(
        rolePermissions: any RolePermissionRepository
    ) {
        self.rolePermissions = rolePermissions
    }
}

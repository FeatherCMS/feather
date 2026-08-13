//
//  RolePermissionCreate.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts

public struct RolePermissionCreate: DTO {
    public let roleId: String
    public let permissionId: String

    public init(
        roleId: String,
        permissionId: String
    ) {
        self.roleId = roleId
        self.permissionId = permissionId
    }
}

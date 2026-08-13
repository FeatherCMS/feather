//
//  RolePermission+DTOs.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain

extension RolePermission {

    var asDetail: RolePermissionDetail {
        .init(
            roleId: roleId,
            permissionId: permissionId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

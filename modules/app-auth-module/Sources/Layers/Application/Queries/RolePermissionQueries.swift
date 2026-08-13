//
//  RolePermissionQueries.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts

public protocol RolePermissionQueries: Sendable {

    func permissions(
        for roleIds: Set<String>
    ) async throws -> Set<String>

    func getBy(
        roleId: String,
        permissionId: String
    ) async throws -> RolePermissionDetail

    func list(
        query: RolePermissionList.Query
    ) async throws -> RolePermissionList

    func count(
        query: RolePermissionList.Query
    ) async throws -> Int
}

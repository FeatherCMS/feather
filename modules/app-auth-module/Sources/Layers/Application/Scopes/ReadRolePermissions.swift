//
//  ReadRolePermissions.swift
//  app-auth-module
//
//  Created by Tibor Bödecs on 2026. 04. 18.
//

public import FeatherModuleKit
public import UserApplication

public struct AuthScope: Scope {

    //    public let system: any SystemQueries
    public let identity: any Identity.Query.Interface
    public let rolePermissions: any RolePermissionQueries

    public init(
        identity: any Identity.Query.Interface,
        rolePermissions: any RolePermissionQueries
    ) {
        self.identity = identity
        self.rolePermissions = rolePermissions
    }
}

//
//  ReadRolePermissions.swift
//  app-auth-module
//
//  Created by Tibor Bödecs on 2026. 04. 18.
//

public import FeatherModuleKit
public import UserModule

public struct AuthScope: Scope {

    //    public let system: any SystemQueries
    public let authorization: any Identity.Authorization.Query.Interface
    public let rolePermissions: any RolePermissionQueries

    public init(
        authorization: any Identity.Authorization.Query.Interface,
        rolePermissions: any RolePermissionQueries
    ) {
        self.authorization = authorization
        self.rolePermissions = rolePermissions
    }
}

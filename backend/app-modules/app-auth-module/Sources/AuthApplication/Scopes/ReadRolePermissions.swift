//
//  File.swift
//  app-auth-module
//
//  Created by Tibor Bödecs on 2026. 04. 18..
//

import Application
import SystemApplication
import UserApplication

public struct AuthScope: Scope {

    //    public let system: any SystemQueries
    public let account: any AccountQueries
    public let rolePermissions: any RolePermissionQueries

    public init(
        account: any AccountQueries,
        rolePermissions: any RolePermissionQueries
    ) {
        self.account = account
        self.rolePermissions = rolePermissions
    }
}

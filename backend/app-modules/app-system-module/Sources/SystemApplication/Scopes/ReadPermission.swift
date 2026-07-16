//
//  ReadPermission.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import SystemDomain

public struct ReadPermission: Scope {
    public let permission: any PermissionQueries

    public init(permission: any PermissionQueries) {
        self.permission = permission
    }
}

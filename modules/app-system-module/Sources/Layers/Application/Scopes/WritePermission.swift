//
//  WritePermission.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import SystemDomain

public struct WritePermission: Scope {
    public let permission: any PermissionRepository

    public init(permission: any PermissionRepository) {
        self.permission = permission
    }
}

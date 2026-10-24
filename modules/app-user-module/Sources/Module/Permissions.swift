//
//  Permissions.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func allPermissions() -> Set<PermissionKey> {
        Identity.Permissions.allPermissions()
            .union(Role.Permissions.allPermissions())
    }
}

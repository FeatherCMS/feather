//
//  Permissions.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func all() -> Set<PermissionKey> {
        Identity.Permissions.all()
            .union(Role.Permissions.all())
    }
}

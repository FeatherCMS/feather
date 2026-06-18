//
//  File.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 18..
//

import Application

public enum SystemPermissions: PermissionProvider {

    public enum Permissions: PermissionProvider {
        static let create = PermissionKey("system:permissions:create")
        static let read = PermissionKey("system:permissions:read")
        static let update = PermissionKey("system:permissions:update")
        static let list = PermissionKey("system:permissions:list")
        static let delete = PermissionKey("system:permissions:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [
                create,
                read,
                update,
                list,
                delete,
            ]
        }
    }

    public enum Variables {
        static let create = PermissionKey("system:variables:create")
        static let read = PermissionKey("system:variables:read")
        static let update = PermissionKey("system:variables:update")
        static let list = PermissionKey("system:variables:list")
        static let delete = PermissionKey("system:variables:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [
                create,
                read,
                update,
                list,
                delete,
            ]
        }
    }

    // MARK: -

    public static func allPermissions() -> Set<PermissionKey> {
        var result: Set<PermissionKey> = .init()
        result.formUnion(Permissions.allPermissions())
        result.formUnion(Variables.allPermissions())
        return result
    }
}

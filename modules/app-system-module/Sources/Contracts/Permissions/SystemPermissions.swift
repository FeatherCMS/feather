//
//  SystemPermissions.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 18.
//

import FeatherContracts

public enum SystemPermissions: PermissionProvider {

    public enum Admin: PermissionProvider {
        public static let access = PermissionKey("system.admin.access")

        public static func allPermissions() -> Set<PermissionKey> {
            [access]
        }
    }

    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("system:permissions:create")
        public static let read = PermissionKey("system:permissions:read")
        public static let update = PermissionKey("system:permissions:update")
        public static let list = PermissionKey("system:permissions:list")
        public static let delete = PermissionKey("system:permissions:delete")

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
        public static let create = PermissionKey("system:variables:create")
        public static let read = PermissionKey("system:variables:read")
        public static let update = PermissionKey("system:variables:update")
        public static let list = PermissionKey("system:variables:list")
        public static let delete = PermissionKey("system:variables:delete")

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

    public enum Jobs {
        public static let read = PermissionKey("system:jobs:read")
        public static let list = PermissionKey("system:jobs:list")

        public static func allPermissions() -> Set<PermissionKey> {
            [read, list]
        }
    }

    // MARK: -

    public static func allPermissions() -> Set<PermissionKey> {
        var result: Set<PermissionKey> = .init()
        result.formUnion(Admin.allPermissions())
        result.formUnion(Permissions.allPermissions())
        result.formUnion(Variables.allPermissions())
        result.formUnion(Jobs.allPermissions())
        return result
    }
}

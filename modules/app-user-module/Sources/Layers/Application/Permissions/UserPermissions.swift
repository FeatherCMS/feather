//
//  UserPermissions.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts

public enum UserPermissions: PermissionProvider {

    public enum Identities: PermissionProvider {
        static let create = PermissionKey("user:identities:create")
        static let read = PermissionKey("user:identities:read")
        static let update = PermissionKey("user:identities:update")
        static let list = PermissionKey("user:identities:list")
        static let delete = PermissionKey("user:identities:delete")
        static let me = PermissionKey("user:identities:me")

        public static func allPermissions() -> Set<PermissionKey> {
            [
                create,
                read,
                update,
                list,
                delete,
                me,
            ]
        }
    }

    public enum Roles: PermissionProvider {
        static let create = PermissionKey("user:roles:create")
        static let read = PermissionKey("user:roles:read")
        static let update = PermissionKey("user:roles:update")
        static let list = PermissionKey("user:roles:list")
        static let delete = PermissionKey("user:roles:delete")

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
        result.formUnion(Identities.allPermissions())
        result.formUnion(Roles.allPermissions())
        return result
    }
}

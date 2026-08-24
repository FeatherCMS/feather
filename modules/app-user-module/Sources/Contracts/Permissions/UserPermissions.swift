//
//  UserPermissions.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherContracts

public enum UserPermissions: PermissionProvider {

    public enum Identities: PermissionProvider {
        public static let create = PermissionKey("user:identities:create")
        public static let read = PermissionKey("user:identities:read")
        public static let update = PermissionKey("user:identities:update")
        public static let list = PermissionKey("user:identities:list")
        public static let delete = PermissionKey("user:identities:delete")
        public static let me = PermissionKey("user:identities:me")

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
        public static let create = PermissionKey("user:roles:create")
        public static let read = PermissionKey("user:roles:read")
        public static let update = PermissionKey("user:roles:update")
        public static let list = PermissionKey("user:roles:list")
        public static let delete = PermissionKey("user:roles:delete")

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

//
//  AuthPermissions.swift
//  app-auth-module
//
//  Created by Tibor Bödecs on 2026. 04. 18.
//

import FeatherContracts

public enum AuthPermissions: PermissionProvider {

    public enum Credential: PermissionProvider {
        public static let create = PermissionKey("auth:credential:create")
        public static let read = PermissionKey("auth:credential:read")
        public static let update = PermissionKey("auth:credential:update")
        public static let delete = PermissionKey("auth:credential:delete")
        public static let find = PermissionKey("auth:credential:find")
        public static let list = PermissionKey("auth:credential:list")

        public static func allPermissions() -> Set<PermissionKey> {
            [
                create,
                read,
                update,
                delete,
                find,
                list,
            ]
        }
    }

    public enum MagicLinks: PermissionProvider {
        public static let create = PermissionKey("auth:magic-links:create")
        public static let read = PermissionKey("auth:magic-links:read")
        public static let update = PermissionKey("auth:magic-links:update")
        public static let list = PermissionKey("auth:magic-links:list")
        public static let delete = PermissionKey("auth:magic-links:delete")

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

    public enum Emails: PermissionProvider {
        public static let create = PermissionKey("auth:auth-email:create")
        public static let read = PermissionKey("auth:auth-email:read")
        public static let update = PermissionKey("auth:auth-email:update")
        public static let delete = PermissionKey("auth:auth-email:delete")
        public static let list = PermissionKey("auth:auth-email:list")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, delete, list]
        }
    }

    public enum AccessControl: PermissionProvider {
        public static let create = PermissionKey("auth:access-control:create")
        public static let read = PermissionKey("auth:access-control:read")
        public static let update = PermissionKey("auth:access-control:update")
        public static let list = PermissionKey("auth:access-control:list")
        public static let delete = PermissionKey("auth:access-control:delete")

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

    public enum Profile: PermissionProvider {
        public static let read = PermissionKey("auth:profile:read")
        public static let update = PermissionKey("auth:profile:update")

        public static func allPermissions() -> Set<PermissionKey> {
            [
                read,
                update,
            ]
        }
    }

    public enum Sessions: PermissionProvider {
        public static let create = PermissionKey("auth:sessions:create")
        public static let read = PermissionKey("auth:sessions:read")
        public static let update = PermissionKey("auth:sessions:update")
        public static let list = PermissionKey("auth:sessions:list")
        public static let delete = PermissionKey("auth:sessions:delete")

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
        result.formUnion(Credential.allPermissions())
        result.formUnion(MagicLinks.allPermissions())
        result.formUnion(Emails.allPermissions())
        result.formUnion(AccessControl.allPermissions())
        result.formUnion(Profile.allPermissions())
        result.formUnion(Sessions.allPermissions())
        return result
    }
}

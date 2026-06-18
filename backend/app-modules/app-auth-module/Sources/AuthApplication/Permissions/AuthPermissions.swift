//
//  File.swift
//  app-auth-module
//
//  Created by Tibor Bödecs on 2026. 04. 18..
//

import Application

public enum AuthPermissions: PermissionProvider {

    public enum Admin: PermissionProvider {
        static let access = PermissionKey("auth:admin:access")

        public static func allPermissions() -> Set<PermissionKey> {
            [
                access
            ]
        }
    }

    public enum MagicLinks: PermissionProvider {
        static let create = PermissionKey("auth:magic-links:create")
        static let read = PermissionKey("auth:magic-links:read")
        static let update = PermissionKey("auth:magic-links:update")
        static let list = PermissionKey("auth:magic-links:list")
        static let delete = PermissionKey("auth:magic-links:delete")

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

    public enum AccessControl: PermissionProvider {
        static let create = PermissionKey("auth:access-control:create")
        static let read = PermissionKey("auth:access-control:read")
        static let update = PermissionKey("auth:access-control:update")
        static let list = PermissionKey("auth:access-control:list")
        static let delete = PermissionKey("auth:access-control:delete")

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
        static let read = PermissionKey("auth:profile:read")
        static let update = PermissionKey("auth:profile:update")

        public static func allPermissions() -> Set<PermissionKey> {
            [
                read,
                update,
            ]
        }
    }

    public enum Settings: PermissionProvider {
        static let read = PermissionKey("auth:settings:read")
        static let update = PermissionKey("auth:settings:update")

        public static func allPermissions() -> Set<PermissionKey> {
            [
                read,
                update,
            ]
        }
    }

    public enum Sessions: PermissionProvider {
        static let create = PermissionKey("auth:sessions:create")
        static let read = PermissionKey("auth:sessions:read")
        static let update = PermissionKey("auth:sessions:update")
        static let list = PermissionKey("auth:sessions:list")
        static let delete = PermissionKey("auth:sessions:delete")

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
        result.formUnion(Admin.allPermissions())
        result.formUnion(MagicLinks.allPermissions())
        result.formUnion(AccessControl.allPermissions())
        result.formUnion(Profile.allPermissions())
        result.formUnion(Settings.allPermissions())
        result.formUnion(Sessions.allPermissions())
        return result
    }
}

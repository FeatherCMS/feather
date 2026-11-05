//
//  Permission+Permissions.swift
//  app-system-module
//

public import FeatherModuleKit

extension Permission {

    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("system:permissions:create")
        public static let read = PermissionKey("system:permissions:read")
        public static let update = PermissionKey("system:permissions:update")
        public static let list = PermissionKey("system:permissions:list")
        public static let delete = PermissionKey("system:permissions:delete")

        public static func all() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}

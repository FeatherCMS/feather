//
//  Variable+Permissions.swift
//  app-system-module
//

public import FeatherModuleKit

extension Variable {

    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("system:variables:create")
        public static let read = PermissionKey("system:variables:read")
        public static let update = PermissionKey("system:variables:update")
        public static let list = PermissionKey("system:variables:list")
        public static let delete = PermissionKey("system:variables:delete")

        public static func all() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}

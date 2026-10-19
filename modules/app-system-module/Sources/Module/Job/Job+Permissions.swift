//
//  Job+Permissions.swift
//  app-system-module
//

public import FeatherModuleKit

extension Job {

    public enum Permissions: PermissionProvider {
        public static let read = PermissionKey("system:jobs:read")
        public static let list = PermissionKey("system:jobs:list")

        public static func all() -> Set<PermissionKey> {
            [read, list]
        }

        public static func allPermissions() -> Set<PermissionKey> {
            all()
        }
    }
}

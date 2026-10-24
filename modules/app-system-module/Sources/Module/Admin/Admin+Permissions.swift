//
//  Admin+Permissions.swift
//  app-system-module
//

public import FeatherModuleKit

extension Admin {

    public enum Permissions: PermissionProvider {
        public static let access = PermissionKey("system.admin.access")

        public static func all() -> Set<PermissionKey> {
            [access]
        }

        public static func allPermissions() -> Set<PermissionKey> {
            all()
        }
    }
}

//
//  Rule+Permissions.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit

extension Rule {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("redirect:rules:create")
        public static let read = PermissionKey("redirect:rules:read")
        public static let update = PermissionKey("redirect:rules:update")
        public static let list = PermissionKey("redirect:rules:list")
        public static let search = PermissionKey("redirect:rules:search")
        public static let delete = PermissionKey("redirect:rules:delete")
        public static let notFoundList = PermissionKey(
            "redirect:not-found:list"
        )

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, search, delete, notFoundList]
        }
    }
}

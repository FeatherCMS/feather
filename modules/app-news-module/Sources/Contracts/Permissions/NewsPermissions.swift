//
//  NewsPermissions.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherContracts

public enum NewsPermissions: PermissionProvider {
    public enum Articles: PermissionProvider {
        public static let create = PermissionKey("news:article:create")
        public static let read = PermissionKey("news:article:read")
        public static let update = PermissionKey("news:article:update")
        public static let list = PermissionKey("news:article:list")
        public static let delete = PermissionKey("news:article:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public enum Categories: PermissionProvider {
        public static let create = PermissionKey("news:category:create")
        public static let read = PermissionKey("news:category:read")
        public static let update = PermissionKey("news:category:update")
        public static let list = PermissionKey("news:category:list")
        public static let delete = PermissionKey("news:category:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public static func allPermissions() -> Set<PermissionKey> {
        Articles.allPermissions()
            .union(Categories.allPermissions())
    }
}

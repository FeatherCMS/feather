//
//  MediaPermissions.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherContracts

public enum MediaPermissions: PermissionProvider {

    public enum Assets: PermissionProvider {
        public static let create = PermissionKey("media:assets:create")
        public static let read = PermissionKey("media:assets:read")
        public static let update = PermissionKey("media:assets:update")
        public static let list = PermissionKey("media:assets:list")
        public static let delete = PermissionKey("media:assets:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public enum Variants: PermissionProvider {
        public static let create = PermissionKey("media:variants:create")
        public static let read = PermissionKey("media:variants:read")
        public static let list = PermissionKey("media:variants:list")
        public static let update = PermissionKey("media:variants:update")
        public static let delete = PermissionKey("media:variants:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, list, update, delete]
        }
    }

    public enum VariantProcessors: PermissionProvider {
        public static let create = PermissionKey("media:variant-processors:create")
        public static let read = PermissionKey("media:variant-processors:read")
        public static let list = PermissionKey("media:variant-processors:list")
        public static let update = PermissionKey("media:variant-processors:update")
        public static let delete = PermissionKey("media:variant-processors:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, list, update, delete]
        }
    }

    public static func allPermissions() -> Set<PermissionKey> {
        var result: Set<PermissionKey> = .init()
        result.formUnion(Assets.allPermissions())
        result.formUnion(Variants.allPermissions())
        result.formUnion(VariantProcessors.allPermissions())
        return result
    }
}

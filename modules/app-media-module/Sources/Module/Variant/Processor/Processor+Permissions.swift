public import FeatherModuleKit

extension Variant.Processor {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey(
            "media:variant-processors:create"
        )
        public static let read = PermissionKey(
            "media:variant-processors:read"
        )
        public static let list = PermissionKey(
            "media:variant-processors:list"
        )
        public static let update = PermissionKey(
            "media:variant-processors:update"
        )
        public static let delete = PermissionKey(
            "media:variant-processors:delete"
        )

        public static func all() -> Set<PermissionKey> {
            [create, read, list, update, delete]
        }

        public static func allPermissions() -> Set<PermissionKey> {
            all()
        }
    }
}

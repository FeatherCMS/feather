public import FeatherModuleKit

public enum Variant {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("media:variants:create")
        public static let read = PermissionKey("media:variants:read")
        public static let list = PermissionKey("media:variants:list")
        public static let update = PermissionKey("media:variants:update")
        public static let delete = PermissionKey("media:variants:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, list, update, delete]
        }
    }

    public enum Repository {}
    public enum Add {}
    public enum Edit {}
    public enum Detail {}
    public enum Remove {}
    public enum Search {}

    public enum Processor {
        public enum Add {}
        public enum Edit {}
        public enum Detail {}
        public enum Remove {}
        public enum Search {}
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

            public static func allPermissions() -> Set<PermissionKey> {
                [create, read, list, update, delete]
            }
        }

        public enum Repository {}
    }
}

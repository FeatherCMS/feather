public import FeatherModuleKit

public enum Asset {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("media:assets:create")
        public static let read = PermissionKey("media:assets:read")
        public static let update = PermissionKey("media:assets:update")
        public static let list = PermissionKey("media:assets:list")
        public static let delete = PermissionKey("media:assets:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public enum File {
        public enum Repository {}
        public enum Add {}
        public enum Edit {}
        public enum GenerateVariant {
            public enum Job {}
            public enum JobController {}
        }
        public enum Detail {}
        public enum PublicResolve {}
        public enum Remove {}
        public enum Resolve {}
        public enum Search {}

        public enum Variant {
            public enum Repository {}
        }
    }

    public enum Folder {
        public enum Repository {}
        public enum Add {}
        public enum Edit {}
        public enum Detail {}
        public enum List {}
    }

    public enum Node {
        public enum SlugPath {}
    }
    public enum Variant {}
    public enum ExtensionMatcher {}
}

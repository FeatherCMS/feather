import Application

public enum MediaPermissions: PermissionProvider {

    public enum Assets: PermissionProvider {
        static let create = PermissionKey("media:assets:create")
        static let read = PermissionKey("media:assets:read")
        static let update = PermissionKey("media:assets:update")
        static let list = PermissionKey("media:assets:list")
        static let delete = PermissionKey("media:assets:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public enum Processors: PermissionProvider {
        static let create = PermissionKey("media:processors:create")
        static let read = PermissionKey("media:processors:read")
        static let list = PermissionKey("media:processors:list")
        static let update = PermissionKey("media:processors:update")
        static let delete = PermissionKey("media:processors:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, list, update, delete]
        }
    }

    public static func allPermissions() -> Set<PermissionKey> {
        var result: Set<PermissionKey> = .init()
        result.formUnion(Assets.allPermissions())
        result.formUnion(Processors.allPermissions())
        return result
    }
}

import Application

public enum RedirectPermissions: PermissionProvider {

    public enum Rules: PermissionProvider {
        public static let create = PermissionKey("redirect:rules:create")
        public static let read = PermissionKey("redirect:rules:read")
        public static let update = PermissionKey("redirect:rules:update")
        public static let list = PermissionKey("redirect:rules:list")
        public static let delete = PermissionKey("redirect:rules:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public enum NotFound: PermissionProvider {
        public static let list = PermissionKey("redirect:not-found:list")

        public static func allPermissions() -> Set<PermissionKey> {
            [list]
        }
    }

    public static func allPermissions() -> Set<PermissionKey> {
        var result: Set<PermissionKey> = .init()
        result.formUnion(Rules.allPermissions())
        result.formUnion(NotFound.allPermissions())
        return result
    }
}

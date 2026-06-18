import Application

public enum WebPermissions: PermissionProvider {

    public enum Pages: PermissionProvider {
        public static let create = PermissionKey("web:pages:create")
        public static let read = PermissionKey("web:pages:read")
        public static let update = PermissionKey("web:pages:update")
        public static let list = PermissionKey("web:pages:list")
        public static let delete = PermissionKey("web:pages:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public enum Metadata: PermissionProvider {
        public static let create = PermissionKey("web:metadata:create")
        public static let read = PermissionKey("web:metadata:read")
        public static let update = PermissionKey("web:metadata:update")
        public static let list = PermissionKey("web:metadata:list")
        public static let delete = PermissionKey("web:metadata:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public enum Menus: PermissionProvider {
        public static let create = PermissionKey("web:menus:create")
        public static let read = PermissionKey("web:menus:read")
        public static let update = PermissionKey("web:menus:update")
        public static let list = PermissionKey("web:menus:list")
        public static let delete = PermissionKey("web:menus:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public enum MenuItems: PermissionProvider {
        public static let create = PermissionKey("web:menu-items:create")
        public static let read = PermissionKey("web:menu-items:read")
        public static let update = PermissionKey("web:menu-items:update")
        public static let list = PermissionKey("web:menu-items:list")
        public static let delete = PermissionKey("web:menu-items:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public enum Settings: PermissionProvider {
        public static let read = PermissionKey("web:settings:read")
        public static let update = PermissionKey("web:settings:update")

        public static func allPermissions() -> Set<PermissionKey> {
            [read, update]
        }
    }

    public static func allPermissions() -> Set<PermissionKey> {
        Pages.allPermissions()
            .union(Metadata.allPermissions())
            .union(Menus.allPermissions())
            .union(MenuItems.allPermissions())
            .union(Settings.allPermissions())
    }
}

import FeatherContracts

public enum AccountPermissions: PermissionProvider {

    public enum Profile: PermissionProvider {
        public static let read = PermissionKey("account:profile:read")
        public static let update = PermissionKey("account:profile:update")
        /// Allows reading and updating profiles belonging to other users.
        public static let manage = PermissionKey("account:profile:manage")

        public static func allPermissions() -> Set<PermissionKey> {
            [read, update, manage]
        }
    }

    public enum Settings: PermissionProvider {
        public static let read = PermissionKey("account:settings:read")
        public static let update = PermissionKey("account:settings:update")
        /// Allows reading and updating settings belonging to other users.
        public static let manage = PermissionKey("account:settings:manage")

        public static func allPermissions() -> Set<PermissionKey> {
            [read, update, manage]
        }
    }

    public enum Invitations: PermissionProvider {
        public static let create = PermissionKey("account:invitations:create")
        public static let read = PermissionKey("account:invitations:read")
        public static let list = PermissionKey("account:invitations:list")
        public static let update = PermissionKey("account:invitations:update")
        public static let delete = PermissionKey("account:invitations:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [
                create,
                read,
                list,
                update,
                delete,
            ]
        }
    }

    public static func allPermissions() -> Set<PermissionKey> {
        var result: Set<PermissionKey> = .init()
        result.formUnion(Profile.allPermissions())
        result.formUnion(Settings.allPermissions())
        result.formUnion(Invitations.allPermissions())
        return result
    }
}

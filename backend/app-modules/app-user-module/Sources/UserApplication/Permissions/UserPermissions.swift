import Application

public enum UserPermissions: PermissionProvider {

    public enum Accounts: PermissionProvider {
        static let create = PermissionKey("user:accounts:create")
        static let read = PermissionKey("user:accounts:read")
        static let update = PermissionKey("user:accounts:update")
        static let list = PermissionKey("user:accounts:list")
        static let delete = PermissionKey("user:accounts:delete")
        static let me = PermissionKey("user:accounts:me")

        public static func allPermissions() -> Set<PermissionKey> {
            [
                create,
                read,
                update,
                list,
                delete,
                me,
            ]
        }
    }

    public enum Roles: PermissionProvider {
        static let create = PermissionKey("user:roles:create")
        static let read = PermissionKey("user:roles:read")
        static let update = PermissionKey("user:roles:update")
        static let list = PermissionKey("user:roles:list")
        static let delete = PermissionKey("user:roles:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [
                create,
                read,
                update,
                list,
                delete,
            ]
        }
    }

    public enum Invitations: PermissionProvider {
        static let create = PermissionKey("user:invitations:create")
        static let read = PermissionKey("user:invitations:read")
        static let list = PermissionKey("user:invitations:list")
        static let update = PermissionKey("user:invitations:update")
        static let delete = PermissionKey("user:invitations:delete")

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

    // MARK: -

    public static func allPermissions() -> Set<PermissionKey> {
        var result: Set<PermissionKey> = .init()
        result.formUnion(Accounts.allPermissions())
        result.formUnion(Roles.allPermissions())
        result.formUnion(Invitations.allPermissions())
        return result
    }
}

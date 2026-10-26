public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func all() -> Set<PermissionKey> {
        Credential.Permissions.all()
            .union(MagicLink.Permissions.all())
            .union(Email.Permissions.all())
            .union(RolePermission.Permissions.all())
            .union(Session.Permissions.all())
    }
}

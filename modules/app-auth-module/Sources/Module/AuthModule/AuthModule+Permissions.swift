public import FeatherModuleKit

extension AuthModule {
    public enum Permissions: PermissionProvider {
        public static func allPermissions() -> Set<PermissionKey> {
            Credential.Permissions.allPermissions()
                .union(MagicLink.Permissions.allPermissions())
                .union(Email.Permissions.allPermissions())
                .union(RolePermission.Permissions.allPermissions())
                .union(Session.Permissions.allPermissions())
        }
    }
}

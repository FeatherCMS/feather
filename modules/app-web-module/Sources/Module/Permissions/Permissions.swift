public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func allPermissions() -> Set<PermissionKey> {
        Page.Permissions.allPermissions()
            .union(Menu.Permissions.allPermissions())
            .union(MenuItem.Permissions.allPermissions())
            .union(Settings.Permissions.allPermissions())
            .union(Metadata.Permissions.allPermissions())
    }
}

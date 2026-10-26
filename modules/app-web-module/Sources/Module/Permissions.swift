public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func all() -> Set<PermissionKey> {
        Page.Permissions.all()
            .union(Menu.Permissions.all())
            .union(MenuItem.Permissions.all())
            .union(Settings.Permissions.all())
            .union(Metadata.Permissions.all())
    }
}

public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func allPermissions() -> Set<PermissionKey> {
        Article.Permissions.allPermissions()
            .union(Category.Permissions.allPermissions())
    }
}

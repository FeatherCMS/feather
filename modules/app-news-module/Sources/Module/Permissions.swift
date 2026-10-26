public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func all() -> Set<PermissionKey> {
        Article.Permissions.all()
            .union(Category.Permissions.all())
    }
}

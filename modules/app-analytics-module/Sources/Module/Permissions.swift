public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func all() -> Set<PermissionKey> {
        Log.Permissions.all()
            .union(Insight.Permissions.all())
            .union(NotFound.Permissions.all())
    }
}

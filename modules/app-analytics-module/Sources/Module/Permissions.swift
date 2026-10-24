public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func allPermissions() -> Set<PermissionKey> {
        Log.Permissions.allPermissions()
            .union(Insight.Permissions.allPermissions())
            .union(NotFound.Permissions.allPermissions())
    }
}

public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func allPermissions() -> Set<PermissionKey> {
        Rule.Permissions.allPermissions()
    }
}

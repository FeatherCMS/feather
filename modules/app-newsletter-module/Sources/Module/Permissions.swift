public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func allPermissions() -> Set<PermissionKey> {
        Campaign.Permissions.allPermissions()
            .union(Subscriber.Permissions.allPermissions())
            .union(Issue.Permissions.allPermissions())
    }
}

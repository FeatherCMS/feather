public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func allPermissions() -> Set<PermissionKey> {
        Profile.Permissions.allPermissions()
            .union(Invitation.Permissions.allPermissions())
            .union(Settings.Permissions.allPermissions())
    }
}

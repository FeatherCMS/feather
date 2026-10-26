public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func all() -> Set<PermissionKey> {
        Profile.Permissions.all()
            .union(Invitation.Permissions.all())
            .union(Settings.Permissions.all())
    }
}

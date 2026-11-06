public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func all() -> Set<PermissionKey> {
        Campaign.Permissions.all()
            .union(Subscriber.Permissions.all())
            .union(Issue.Permissions.all())
    }
}

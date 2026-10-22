public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func all() -> Set<PermissionKey> {
        Asset.Permissions.all()
            .union(Variant.Permissions.all())
            .union(Variant.Processor.Permissions.all())
    }

    public static func allPermissions() -> Set<PermissionKey> {
        all()
    }
}

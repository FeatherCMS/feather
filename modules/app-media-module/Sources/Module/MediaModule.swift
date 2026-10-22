public import FeatherModuleKit

public enum MediaModule {
    public enum Event {}

    public enum Permissions: PermissionProvider {
        public static func allPermissions() -> Set<PermissionKey> {
            Asset.Permissions.allPermissions()
                .union(Variant.Permissions.allPermissions())
                .union(Variant.Processor.Permissions.allPermissions())
        }
    }
}

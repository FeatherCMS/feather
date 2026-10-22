public import FeatherModuleKit

public enum Log {
    public enum Filter {
        public protocol Interface: Sendable {
            func shouldTrack(
                path: String,
                method: String,
                responseCode: Int
            ) -> Bool
        }
    }

    public enum Permissions: PermissionProvider {
        public static let list = PermissionKey("analytics:logs:list")

        public static func allPermissions() -> Set<PermissionKey> {
            [list]
        }
    }
}

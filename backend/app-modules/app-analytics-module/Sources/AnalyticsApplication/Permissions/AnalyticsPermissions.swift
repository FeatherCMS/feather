import Application

public enum AnalyticsPermissions: PermissionProvider {

    public enum Logs: PermissionProvider {
        public static let list = PermissionKey("analytics:logs:list")

        public static func allPermissions() -> Set<PermissionKey> {
            [list]
        }
    }

    public enum Insights: PermissionProvider {
        public static let list = PermissionKey("analytics:insights:list")

        public static func allPermissions() -> Set<PermissionKey> {
            [list]
        }
    }

    public static func allPermissions() -> Set<PermissionKey> {
        var result: Set<PermissionKey> = .init()
        result.formUnion(Logs.allPermissions())
        result.formUnion(Insights.allPermissions())
        return result
    }
}

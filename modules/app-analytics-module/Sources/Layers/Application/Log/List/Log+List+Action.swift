import AnalyticsDomain
public import AnalyticsModule
public import FeatherModuleKit

extension Log.List {
    public struct Action: PermissionAction {
        public let key = Log.Permissions.list
    }
}

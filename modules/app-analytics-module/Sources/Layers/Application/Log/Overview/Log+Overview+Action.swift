import AnalyticsDomain
public import AnalyticsModule
public import FeatherModuleKit

extension Log.Overview {
    public struct Action: PermissionAction {
        public let key = Insight.Permissions.list
    }
}

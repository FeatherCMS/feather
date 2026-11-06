import AnalyticsDomain
public import AnalyticsModule
public import FeatherModuleKit

extension Log.Detail {
    public struct Action: PermissionAction {
        public let key = Log.Permissions.list
    }
}

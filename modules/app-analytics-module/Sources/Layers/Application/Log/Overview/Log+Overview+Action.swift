import AnalyticsModule
import AnalyticsDomain
import FeatherModuleKit

extension Log.Overview {
    struct Action: PermissionAction {
        let key = Insight.Permissions.list
    }
}

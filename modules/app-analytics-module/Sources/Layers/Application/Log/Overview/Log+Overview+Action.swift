import AnalyticsContracts
import FeatherModuleKit

extension Log.Overview {
    struct Action: PermissionAction {
        let key = AnalyticsPermissions.Insights.list
    }
}

import AnalyticsContracts
import AnalyticsDomain
import FeatherModuleKit

extension Log.Detail {
    struct Action: PermissionAction {
        let key = AnalyticsPermissions.Logs.list
    }
}

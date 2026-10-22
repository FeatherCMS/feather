import AnalyticsModule
import AnalyticsDomain
import FeatherModuleKit

extension Log.Detail {
    struct Action: PermissionAction {
        let key = Log.Permissions.list
    }
}

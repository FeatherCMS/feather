import AnalyticsModule
import AnalyticsDomain
import FeatherModuleKit

extension Log.List {
    struct Action: PermissionAction {
        let key = Log.Permissions.list
    }
}

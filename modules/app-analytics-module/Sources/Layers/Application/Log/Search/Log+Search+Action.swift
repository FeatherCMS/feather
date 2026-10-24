import AnalyticsDomain
import AnalyticsModule
import FeatherApplication
import FeatherModuleKit

extension Log.Search {
    struct Action: PermissionAction {
        let key = Log.Permissions.list
    }
}

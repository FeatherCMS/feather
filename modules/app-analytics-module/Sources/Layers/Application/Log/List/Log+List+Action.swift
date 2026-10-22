import AnalyticsContracts
import FeatherModuleKit

extension Log.List {
    struct Action: PermissionAction {
        let key = AnalyticsPermissions.Logs.list
    }
}

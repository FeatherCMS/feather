import AnalyticsAdminAPI
import AnalyticsModule

extension Log.View {
    struct Model: Sendable {
        let log: Components.Schemas.AnalyticsLogDetailSchema
    }
}

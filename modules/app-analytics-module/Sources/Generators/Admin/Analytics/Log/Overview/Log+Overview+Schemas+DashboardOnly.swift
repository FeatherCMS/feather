import FeatherOpenAPI

extension Analytics.Log.Overview.Schemas {
    struct DashboardOnly: BoolSchemaRepresentable {
        var openAPIIdentifier: String {
            "AnalyticsLogOverviewDashboardOnlyField"
        }
    }
}

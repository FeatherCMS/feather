import FeatherOpenAPI

extension Analytics.Log.Overview.Schemas {
    struct KPIValue: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogOverviewKPIField" }
        var example: Double? = 123
    }
}

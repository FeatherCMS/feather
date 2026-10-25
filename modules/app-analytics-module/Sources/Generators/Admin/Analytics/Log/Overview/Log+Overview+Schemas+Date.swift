import FeatherOpenAPI

extension Analytics.Log.Overview.Schemas {
    struct Date: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogOverviewDateField" }
        var example: Double? = 1_717_171_717
    }
}

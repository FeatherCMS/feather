import FeatherOpenAPI

extension Analytics.Log.Overview.Schemas {
    struct KPIInt: IntSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogOverviewKPIIntField" }
        var example: Int? = 123
    }
}

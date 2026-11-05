import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogIdField" }
        var example: String? = "analytics-log-01"
    }
}

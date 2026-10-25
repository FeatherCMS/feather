import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct URL: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogURLField" }
        var example: String? = "https://example.com/admin/analytics/logs/"
    }
}

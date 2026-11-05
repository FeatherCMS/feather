import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct IP: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogIPField" }
        var example: String? = "203.0.113.10"
    }
}

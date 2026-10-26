import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct Origin: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogOriginField" }
        var example: String? = "https://example.com"
    }
}

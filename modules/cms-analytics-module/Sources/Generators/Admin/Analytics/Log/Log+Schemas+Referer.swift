import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct Referer: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogRefererField" }
        var example: String? = "https://example.com/admin/"
    }
}

import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct UserAgent: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogUserAgentField" }
        var example: String? = "Mozilla/5.0"
    }
}

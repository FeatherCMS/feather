import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct Search: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogSearchField" }
        var example: String? = "chrome"
    }
}

import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct Method: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogMethodField" }
        var example: String? = "GET"
    }
}

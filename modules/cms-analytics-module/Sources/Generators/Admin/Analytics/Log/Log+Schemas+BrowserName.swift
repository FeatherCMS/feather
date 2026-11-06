import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct BrowserName: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogBrowserNameField" }
        var example: String? = "Safari"
    }
}

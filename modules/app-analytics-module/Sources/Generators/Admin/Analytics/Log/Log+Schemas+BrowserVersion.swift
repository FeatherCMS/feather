import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct BrowserVersion: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogBrowserVersionField" }
        var example: String? = "17.5"
    }
}

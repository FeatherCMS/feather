import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct Source: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogSourceField" }
        var example: String? = "web_app"
    }
}

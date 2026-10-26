import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct EngineName: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogEngineNameField" }
        var example: String? = "WebKit"
    }
}

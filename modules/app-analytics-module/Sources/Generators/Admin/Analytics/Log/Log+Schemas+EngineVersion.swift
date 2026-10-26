import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct EngineVersion: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogEngineVersionField" }
        var example: String? = "617.1"
    }
}

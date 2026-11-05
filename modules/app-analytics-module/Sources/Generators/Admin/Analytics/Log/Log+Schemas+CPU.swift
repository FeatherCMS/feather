import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct CPU: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogCPUField" }
        var example: String? = "arm64"
    }
}

import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct OSVersion: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogOSVersionField" }
        var example: String? = "15.0"
    }
}

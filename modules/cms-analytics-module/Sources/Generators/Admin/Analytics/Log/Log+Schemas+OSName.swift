import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct OSName: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogOSNameField" }
        var example: String? = "macOS"
    }
}

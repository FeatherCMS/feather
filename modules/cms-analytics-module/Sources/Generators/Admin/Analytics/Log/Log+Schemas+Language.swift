import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct Language: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogLanguageField" }
        var example: String? = "en"
    }
}

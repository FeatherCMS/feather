import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct AcceptLanguage: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogAcceptLanguageField" }
        var example: String? = "en-US,en;q=0.9"
    }
}

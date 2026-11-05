import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct Headers: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogHeadersField" }
        var example: String? = "{\"accept\":\"application/json\"}"
    }
}

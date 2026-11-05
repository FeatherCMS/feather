import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct Region: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogRegionField" }
        var example: String? = "US"
    }
}

import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct ResponseCode: IntSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogResponseCodeField" }
        var example: Int? = 200
    }
}

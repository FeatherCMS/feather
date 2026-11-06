import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct Timestamp: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogTimestampField" }
        var example: Double? = 1_717_171_717
    }
}

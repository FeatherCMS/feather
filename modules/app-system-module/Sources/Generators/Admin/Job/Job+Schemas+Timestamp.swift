import FeatherOpenAPI

extension Job.Schemas {
    struct Timestamp: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "SystemJobTimestampField" }
    }
}

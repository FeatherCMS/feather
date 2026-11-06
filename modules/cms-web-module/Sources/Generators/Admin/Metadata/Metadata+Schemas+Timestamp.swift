import FeatherOpenAPI

extension Metadata.Schemas {
    struct Timestamp: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "MetadataTimestampField" }
        var example: Double? = 1_760_000_000
    }
}

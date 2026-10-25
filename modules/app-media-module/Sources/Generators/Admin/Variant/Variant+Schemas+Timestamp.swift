import FeatherOpenAPI

extension Variant.Schemas {
    struct Timestamp: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "MediaVariantTimestampField" }
        var example: Double? = 1_717_171_717
    }
}

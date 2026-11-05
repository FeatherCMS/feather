import FeatherOpenAPI

extension Metadata.Schemas {
    struct TimestampField: DoubleSchemaRepresentable {
        var example: Double? { 1_760_000_000 }
    }
}

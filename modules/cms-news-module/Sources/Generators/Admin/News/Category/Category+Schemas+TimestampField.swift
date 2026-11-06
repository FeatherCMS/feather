import FeatherOpenAPI

extension Category.Schemas {
    struct TimestampField: DoubleSchemaRepresentable {
        var example: Double? { 1_760_000_000 }
    }
}

import FeatherOpenAPI

extension Article.Schemas {
    struct TimestampField: DoubleSchemaRepresentable {
        var example: Double? { 1_760_000_000 }
    }
}

import FeatherOpenAPI

extension Tag.Schemas {
    struct CreatedAt: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "BlogTagCreatedAtField" }
        var example: Double? { 1_760_000_000 }
    }
}

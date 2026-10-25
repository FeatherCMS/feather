import FeatherOpenAPI

extension Tag.Schemas {
    struct UpdatedAt: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "BlogTagUpdatedAtField" }
        var example: Double? { 1_760_000_000 }
    }
}

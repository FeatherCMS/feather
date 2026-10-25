import FeatherOpenAPI

extension Author.Schemas {
    struct UpdatedAt: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorUpdatedAtField" }
        var example: Double? { 1_760_000_000 }
    }
}

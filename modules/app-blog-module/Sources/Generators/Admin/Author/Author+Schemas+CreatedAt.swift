import FeatherOpenAPI

extension Author.Schemas {
    struct CreatedAt: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorCreatedAtField" }
        var example: Double? { 1_760_000_000 }
    }
}

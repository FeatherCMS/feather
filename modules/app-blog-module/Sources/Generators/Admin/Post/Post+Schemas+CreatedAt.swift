import FeatherOpenAPI

extension Post.Schemas {
    struct CreatedAt: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "BlogPostCreatedAtField" }
        var example: Double? { 1_760_000_000 }
    }
}
